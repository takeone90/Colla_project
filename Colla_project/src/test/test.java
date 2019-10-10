package test;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:WebContent/WEB-INF/spring/root-context.xml")
public class test {
	
	@Test
	public void serviceTest() throws ParseException {
		String startDate = "2019-10-01";
		String endDate = "2019-10-10";
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
		Date encStartDate = dt.parse(startDate);
		Date encEndDate = dt.parse(endDate);
		System.out.println("encStartDate : " + encStartDate);
		System.out.println("encEndDate : " + encEndDate);
		
	}
}
