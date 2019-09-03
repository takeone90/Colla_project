package commons;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

public class DownloadView extends AbstractView{
	private File file;
	
	public DownloadView(File file) {
		this.file = file;
		setContentType("application/download;charset=utf-8");
	}
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		response.setContentLengthLong(file.length());
		String fullName = file.getName();
		String originName = fullName.substring(fullName.indexOf("_") + 1);
		
		originName = URLEncoder.encode(originName, "UTF-8");
		
		response.setHeader("Content-Disposition", "attachment;filename=\""+originName+ "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		
		OutputStream out = null;
		FileInputStream in = null;
		
		try {
			out = response.getOutputStream();
			in = new FileInputStream(file);
			FileCopyUtils.copy(in, out);
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(in != null)
				in.close();
		}
		out.flush();
	}

}
