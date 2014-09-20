<!--

BigBlueButton - http://www.bigbluebutton.org

Copyright (c) 2008-2009 by respective authors (see below). All rights reserved.

BigBlueButton is free software; you can redistribute it and/or modify it under the 
terms of the GNU Lesser General Public License as published by the Free Software 
Foundation; either version 3 of the License, or (at your option) any later 
version. 

BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY 
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along 
with BigBlueButton; if not, If not, see <http://www.gnu.org/licenses/>.

Author: Fred Dixon <ffdixon@bigbluebutton.org>

-->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.cyou.util.ConnectionUtil" %>
<%@ page import="java.sql.*,java.util.*" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<% 
	request.setCharacterEncoding("UTF-8"); 
	response.setCharacterEncoding("UTF-8"); 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<%@ include file="bbb_api.jsp"%>
<% 
if (request.getParameterMap().isEmpty()) {
%>
<script language="javascript" type="text/javascript">
  window.location.href="www.phas.cn/index";
</script>
<%
} else if (request.getParameter("action").equals("create")) {
		
		String userId = request.getParameter("username");
		String meetingID = "";
		String password = "";
		Connection con =  ConnectionUtil.getConnection();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("select c.COURSE_TITLE as courseTitle,c.COURSE_PASSWORD as code from PRIVATE_COURSE c where c.USER_ID='" + userId + "'");
		while(rs.next()){
		  meetingID = rs.getString("courseTitle");
		  password = rs.getString("code");
		}
		ConnectionUtil.release(rs,stat,con);
		String welcomeMsg = "欢迎您来到9527在线课堂";
		String logoutURL = "http://www.phas.cn/index";
		Random random = new Random();
		//
		// Looks good, let's create the meeting
		//
		String meeting_ID = createMeeting( meetingID, welcomeMsg, password, password, null, logoutURL );
		System.out.println("meeting_ID:" + meeting_ID);
		//
		// Check if we have an error.
		//
		if( meeting_ID.startsWith("Error ")) {
%>

Error: createMeeting() failed
<p /><%=meeting_ID%> 

<%
			return;
		}
		
		//
		// We've got a valid meeting_ID and passoword -- let's join!
		//
		
		String joinURL = getJoinMeetingURL(userId, meeting_ID, password, null);
%>

<script language="javascript" type="text/javascript">
  window.location.href="<%=joinURL%>";
</script>

<%
	} else if(request.getParameter("action").equals("join")){
		String userId = request.getParameter("username");
		String meetingID = "";
		String  password = request.getParameter("code");
		Connection con =  ConnectionUtil.getConnection();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("select c.COURSE_TITLE as courseTitle,c.COURSE_PASSWORD as code from PRIVATE_COURSE c where c.COURSE_PASSWORD='" + password + "'");
		while(rs.next()){
		  meetingID = rs.getString("courseTitle");
		}
		ConnectionUtil.release(rs,stat,con);
		System.out.println("meetingID:" + meetingID);
		String isMeetingRunning = isMeetingRunning(meetingID);
		System.out.println("isMeetingRunning:" + isMeetingRunning);
		
		if(isMeetingRunning.equals("")){
			
		}else{
			String joinURL = getJoinMeetingURL(userId, meetingID, password, null);
%>
<script language="javascript" type="text/javascript">
  window.location.href="<%=joinURL%>";
</script>
<%
		}
		
	}
%>

 
<%@ include file="demo_footer.jsp"%>

</body>
</html>


