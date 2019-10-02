package model;

public class SetAlarm {
	int num;
	int workspace;
	int notice;
	int reply;
	int projectInvite;
	int todo;
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getWorkspace() {
		return workspace;
	}
	public void setWorkspace(int workspace) {
		this.workspace = workspace;
	}
	public int getNotice() {
		return notice;
	}
	public void setNotice(int notice) {
		this.notice = notice;
	}
	public int getReply() {
		return reply;
	}
	public void setReply(int reply) {
		this.reply = reply;
	}
	@Override
	public String toString() {
		return "SetAlarm [num=" + num + ", workspace=" + workspace + ", notice=" + notice + ", reply=" + reply + "]";
	}
	public int getProjectInvite() {
		return projectInvite;
	}
	public void setProjectInvite(int projectInvite) {
		this.projectInvite = projectInvite;
	}
	public int getTodo() {
		return todo;
	}
	public void setTodo(int todo) {
		this.todo = todo;
	}
}
