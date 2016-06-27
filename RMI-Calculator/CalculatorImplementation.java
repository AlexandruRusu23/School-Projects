import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
import java.util.*;
import java.lang.*;

public class CalculatorImplementation extends UnicastRemoteObject implements Calculator
{
	public CalculatorImplementation() throws RemoteException {}
	
	public double makeSum(double x, double y) throws RemoteException
	{
		return x+y;
	}
	public double makeDif(double x, double y) throws RemoteException
	{
		return x-y;
	}
	public double makeProd(double x, double y) throws RemoteException
	{
		return x*y;
	}
	public double makeDiv(double x, double y) throws RemoteException
	{
		return x/y;
	}
	public double makeInverted(double x) throws RemoteException
	{
		return 1/x;
	}
	public double makePower(double x, double y) throws RemoteException
	{
		double expo=y;
		double rez=1;
		while(expo>0)
		{
			rez*=x;
			expo--;
		}
		return rez;
	}
	public double makeFactorial(double x) throws RemoteException
	{
		double result=1;
		for(int i=1;i<=x;i++)
		{
			result*=i;
		}
		return result;
	}
	public double makeSqrt(double x) throws RemoteException
	{
		double result=x;
		return Math.sqrt(result);
	}
	
}