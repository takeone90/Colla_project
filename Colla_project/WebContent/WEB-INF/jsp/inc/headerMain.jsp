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
		<div id="m-gnb">
			<div class="gnbBtn">
				<a href="#"></a>
				<ul>
					<li></li>
					<li></li>
					<li></li>
				</ul>
			</div>
			<script type="text/javascript">
				$(function(){
					$("#m-gnb .gnbBtn a").click(function(){
						$(this).next("ul").toggleClass("active");
						$("#m-gnb .gnbUl").toggleClass("active");
						return false;
					});
				});
			</script>
			<ul class="gnbUl">
				<li>
					<h2>
						<a lang="en" href="${contextPath}/collaInfo"> COLLA? </a>
					</h2>
				</li>
			 <li>
					<h2>
						<a lang="en" href="${contextPath}/pricing"> PRICING </a>
					</h2>
				</li>
				<li>
					<h2>
						<a lang="en" href="${contextPath}/faq"> FAQ </a>
					</h2>
				</li>
			 	<li>
					<h2>
						<a lang="en" href="${contextPath}/aboutUs"> ABOUT US </a>
					</h2>
				</li>
				<li class="memberBtn">
					<c:choose>
						<c:when test="${sessionScope.user != null }">
							<a lang="en" href="${contextPath}/workspace" class="btn">Workspace</a>
							<a lang="en" href="${contextPath}/logout" class="btn">Logout</a>
						</c:when>
						<c:otherwise>
							<a lang="en" href="${contextPath}/loginForm" class="btn">Login</a>
							<a lang="en" href="${contextPath}/joinStep1" class="btn">Join us</a>
						</c:otherwise>
					</c:choose>
				</li>
			</ul>
		</div>
		<nav id="gnb" class="floatleft">
			<ul>
				<li>
					<h2>
						<a lang="en" href="${contextPath}/collaInfo"> COLLA? </a>
					</h2>
				</li>
			 	<li>
					<h2>
						<a lang="en" href="${contextPath}/pricing"> PRICING </a>
					</h2>
				</li>
			 	<li>
					<h2>
						<a lang="en" href="${contextPath}/faq"> FAQ </a>
					</h2>
				</li>
				<li>
					<h2>
						<a lang="en" href="${contextPath}/aboutUs"> ABOUT US </a>
					</h2>
				</li>
			</ul>
		</nav>
		<div id="member-nav" class="floatleft">
			<ul>
			<c:choose>
				<c:when test="${sessionScope.user != null }">
					<li><a lang="en" href="${contextPath}/workspace" class="btn">Workspace</a></li>
					<li><a lang="en" href="${contextPath}/logout" class="btn">Logout</a></li>
				</c:when>
				<c:otherwise>
					<li><a lang="en" href="${contextPath}/loginForm" class="btn">Login</a></li>
					<li><a lang="en" href="${contextPath}/joinStep1" class="btn">Join us</a></li>
				</c:otherwise>
			</c:choose>
			</ul>
		</div>
	</div>
</div>
