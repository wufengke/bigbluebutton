<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
  window.location.href="http://class.agaokao.com/index";
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
		if(meetingID == null || "".equals(meetingID)){
			String errorUrl = "http://class.agaokao.com/member/my_podium?error=2";
			%>
			<script language="javascript" type="text/javascript">
		  		window.location.href="<%=errorUrl%>";
			</script>
			<%
		}
		String welcomeMsg = "欢迎您来到9527在线课堂";
		String logoutURL = "http://class.agaokao.com/member/my_course";
		String isMeetingRunning = isMeetingRunning(meetingID);
		if(!"true".equals(isMeetingRunning)){
			String meeting_ID = createMeeting( meetingID, welcomeMsg, password, password, null, logoutURL );
			System.out.println("meeting_ID:" + meeting_ID);
			if( meeting_ID.startsWith("Error ")) {
				String errorUrl = "http://class.agaokao.com/member/my_podium?error=1";
			%>
			<script language="javascript" type="text/javascript">
		  		window.location.href="<%=errorUrl%>";
			</script>
			<%
			}
			String joinURL = getJoinMeetingURL(userId, meeting_ID, password, null);
			%>
	
			<script language="javascript" type="text/javascript">
			  window.location.href="<%=joinURL%>";
			</script>
		<%
			}else{
				//教师已经存在直接进入
				String joinURL = getJoinMeetingURL(userId, meetingID, password, null);
			
		%>
			<script language="javascript" type="text/javascript">
		 		window.location.href="<%=joinURL%>";
			</script>
		<% 
			}
		%>

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
		if(meetingID == null || "".equals(meetingID)){
			String errorUrl = "http://class.agaokao.com/member/my_course?error=2";
			%>
			<script language="javascript" type="text/javascript">
		  		window.location.href="<%=errorUrl%>";
			</script>
			<%
		}
		System.out.println("meetingID:" + meetingID);
		String isMeetingRunning = isMeetingRunning(meetingID);
		System.out.println("isMeetingRunning:" + isMeetingRunning);
		if(!"true".equals(isMeetingRunning)){
			String errorUrl = "http://class.agaokao.com/member/my_course?error=1";
		%>
		<script language="javascript" type="text/javascript">
		  window.location.href="<%=errorUrl%>";
		</script>
		<%
		}else{
			String joinURL = getJoinMeetingURL(userId, meetingID, password, null);
		%>
		<script language="javascript" type="text/javascript">
		  window.location.href="<%=joinURL%>";
		</script>
		<%
		}
		
	}else{
		
	}
%>
<%@ include file="demo_footer.jsp"%>
</body>
</html>