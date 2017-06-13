public with sharing class Banderas_cls
{
	private static set<String> stEjecutado = new set<String>();
	public static boolean ValidarEjecucion(String nombre)
	{		
		return stEjecutado.contains(nombre);
	}
	public static void setEjecucion(string nombre)
	{
		stEjecutado.add(nombre);
	}
}