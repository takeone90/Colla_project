<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<div id="header">
	<div class="container clearFix">
		<h1 id="logo" class="floatleft">
			<a href="${contextPath}/"> <img src="${contextPath }/img/COLLA_LOGO_200px.png" />
			</a>
		</h1>
		<nav class="floatleft">
			<ul>
				<li>
					<h2>
						<a href="${contextPath}/collaInfo"> COLLA? </a>
					</h2>
				</li><!-- 
			 --><li>
					<h2>
						<a href="${contextPath}/pricing"> PRICING </a>
					</h2>
				</li><!-- 
			 --><li>
					<h2>
						<a href="${contextPath}/faq"> FAQ </a>
					</h2>
				</li><!-- 
			 --><li>
					<h2>
						<a href="${contextPath}/aboutUs"> ABOUT US </a>
					</h2>
				</li>
			</ul>
		</nav>
		<div id="member-nav" class="floatleft">
			<ul>
			<c:choose>
				<c:when test="${sessionScope.user != null }">
					<li><a href="${contextPath}/workspace" class="btn">Workspace</a></li>
					<li><a href="${contextPath}/logout" class="btn">Logout</a></li>
				</c:when>
				<c:otherwise>
					<li><a href="${contextPath}/loginForm" class="btn">Login</a></li>
					<li><a href="${contextPath}/joinStep1" class="btn">Join us</a></li>
				</c:otherwise>
			</c:choose>
				
			</ul>
		</div>
	</div>
</div>
