<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<div id="header">
	<div class="container clearFix">
		<h1 id="logo" class="floatleft">
			<a href="${contextPath }/main"> <img src="${contextPath }/img/COLLA_LOGO_200px.png" />
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
				<li><a href="${contextPath}/loginForm" class="member-btn">Login</a></li>
				<li><a href="${contextPath}/joinStep1" class="member-btn">Join us</a></li>
				<!-- 				<li> -->
				<!-- 					<a href="#" class="member-btn">Workspace로 이동</a> -->
				<!-- 				</li> -->
				<!-- 				<li> -->
				<!-- 					<a href="#" class="member-btn">LOGOUT</a> -->
				<!-- 				</li> -->
			</ul>
		</div>
	</div>
</div>