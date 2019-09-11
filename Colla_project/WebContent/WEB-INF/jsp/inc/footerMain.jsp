<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<c:set var="member" value="<%=request.getSession().getAttribute(\"user\")%>" />
<script type="text/javascript" src="${contextPath }/js/stomp.js"></script>
<script type="text/javascript" src="${contextPath }/js/sockjs.js"></script>
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
	<div id="f1">
		<p>© 2019 Osiris systems inc. All rights reserved.</p>
		<p>United States | 2035 Sunset Lake Road, Suite B-2. Newark, Delaware 19702.</p>
		<p>South Korea | 140 Sapyeong-daero, Seocho-gu, Seoul | support@beecanvas.com</p>
	</div>
	<div id="f2">
		<div id="co-logo">
			<h1>질 수 없조</h1>
		</div>
		<div id="co-sns">
			<ul>
				<li>
					<a href="#">
						<span>Instagram</span>
					</a>
				</li>
				<li>
					<a href="#">
						<span>Facebook</span>
					</a>
				</li>
				<li>
					<a href="#">
						<span>Youtube</span>
					</a>
				</li>
			</ul>
		</div>
	</div>
	<button onclick="topFunction()" id="btn_page_top">TOP</button>
</div>