package model;

public class Pessoa {
	
	private int id;
	private String nome;
	
	protected int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	protected String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	@Override
	public String toString() {
		return "pessoa [id=" + id + ", nome=" + nome + "]";
	}
	
	
	

}
