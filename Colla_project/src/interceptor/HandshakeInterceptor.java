package interceptor;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

public class HandshakeInterceptor extends HttpSessionHandshakeInterceptor {

	@Resource(name = "connectorList")
	private Map<Object,String> connectorList;//빈으로 등록된 접속자명단(email, session)
	
	@Override
	public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
			Exception ex) {
		System.out.println("핸드쉐이크 연결되었습니다.");
		System.out.println("접속세션 : " + connectorList);
	}
	
}
