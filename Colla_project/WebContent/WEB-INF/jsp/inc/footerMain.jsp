<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<c:set var="member" value="<%=request.getSession().getAttribute(\"user\")%>" />
<script type="text/javascript" src="${contextPath }/js/stomp.js"></script>
<script type="text/javascript" src="${contextPath }/js/sockjs.js"></script>
<script src="https://kit.fontawesome.com/ac21eff7ec.js"></script>
<script>
window.onscroll = function() {scrollFunction()};
function scrollFunction() {
  if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
    $("#btn_page_top").css('display', 'block');
  } else {
	  $("#btn_page_top").css('display', 'none');
  }
}
function topFunction() {
  document.documentElement.scrollTop = 0;
}
</script>
<div id="footer">
	<div id="footer-all">
		<div id="f1">
			<div id="co-logo">
				<img src="${contextPath }/img/COLLA_LOGO_200px.png" alt="colla 로고">
			</div>
			<div id="co-location">
				<p><span>(주)질수없조</span><span>명예이사 : 임창목</span><span>사업자등록번호 : 1990-09-17</span></p>
				<p><span>Republic of Korea</span><span>459, Gangnam-daero, Seocho-gu, Seoul</span></p>
			</div>
		</div>
		<div id="f2">
			<p>© 2019 NeverLose systems inc. All rights reserved.</p>
			<div id="co-sns">
				<ul>
					<li>
						<a href="#">
							<span><i class="fab fa-instagram"></i></span>
						</a>
					</li>
					<li>
						<a href="#">
							<span><i class="fab fa-facebook-square"></i></span>
						</a>
					</li>
					<li>
						<a href="#">
							<span><i class="fab fa-youtube"></i></span>
						</a>
					</li>
				</ul>
			</div> <!-- co-sns -->
		</div><!-- f2 -->
		
	</div>
	<button onclick="topFunction()" id="btn_page_top">TOP</button>
</div>