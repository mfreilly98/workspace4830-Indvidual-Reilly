<%@ page language="java" import="java.sql.*"
	contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Simple DB Connection</title>
</head>
<body>
	<h1 align="center"> Database Result (JSP) </h1>
	<%!String keyword;%>
	<%keyword = request.getParameter("keyword");%>
	<%=runMySQL()%>

	<%!String runMySQL() throws SQLException {
		System.out.println("[DBG] User entered keyword: " + keyword);
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			System.out.println("Where is your MySQL JDBC Driver?");
			e.printStackTrace();
			return null;
		}

		System.out.println("MySQL JDBC Driver Registered!");
		Connection connection = null;

		try {
			connection = DriverManager.getConnection("jdbc:mysql://ec2-18-188-36-127.us-east-2.compute.amazonaws.com:3306/toDoList", "newmysqlremoteuser", "mypassword");
		} catch (SQLException e) {
			System.out.println("Connection Failed! Check output console");
			e.printStackTrace();
			return null;
		}

		if (connection != null) {
			System.out.println("You made it, take control your database now!");
		} else {
			System.out.println("Failed to make connection!");
		}

		PreparedStatement query = null;
		StringBuilder sb = new StringBuilder();

		try {
			connection.setAutoCommit(false);

			if (keyword.isEmpty()) {
				String selectSQL = "SELECT * FROM toDoList";
				query = connection.prepareStatement(selectSQL);
			} else {
				String selectSQL = "SELECT * FROM toDoList WHERE MYUSER LIKE ?";
				String Activity = keyword + "%";
				query = connection.prepareStatement(selectSQL);
				query.setString(1, Activity);
			}
			
			//String qSql = "SELECT * FROM toDoList";
			//query = connection.prepareStatement(qSql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = query.executeQuery();
			while (rs.next()) {
				int NUM = rs.getInt("NUM");
				String ACTIVITY = rs.getString("ACTIVITY").trim();
				String DUE = rs.getString("DUE").trim();

				// Display values to console.
				System.out.println("#: " + NUM + ", ");
				System.out.println("Task to do: " + ACTIVITY + ", ");
				System.out.println("Due Date: " + DUE + "<br>");
				// Display values to webpage.
				sb.append("#: " + NUM + ", ");
				sb.append("Task to Do: " + ACTIVITY + ", ");
				sb.append("Due Date: " + DUE + "<br>");
			}
			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sb.toString();
	}%>

	<a href=/webproject-Indvidual-Reilly/simpleFormSearchJSP.html>Search List</a> <br>
</body>
</html>