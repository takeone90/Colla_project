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
	public void serviceTest() {
		String startDate = "2019-10-01";
		String endDate = "2019-10-10";
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
		try {
			Date encStartDate = dt.parse(startDate);
			Date encEndDate = dt.parse(endDate);
			int onlyStartDate = encStartDate.getDate();
			int onlyEndDate = encEndDate.getDate();
			System.out.println("날짜 차이 : "+(onlyEndDate-onlyStartDate));
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
}
