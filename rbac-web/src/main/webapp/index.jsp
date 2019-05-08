<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>创意产品众筹平台</title>
<link rel="stylesheet" href="${applicationScope.APP_PATH}/static/bootstrap/css/bootstrap.min.css">
</head>
<body>
  <h2>Hello World! ${applicationScope.APP_PATH}</h2>
  <h3>Hello World! ${pageContext.request.contextPath}</h3>

  <%--跳转到登录页面--%>
  <jsp:forward page="WEB-INF/jsp/login.jsp"/>
</body>
</html>
