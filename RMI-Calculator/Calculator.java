import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
import java.util.*;
import java.lang.*;

public interface Calculator extends Remote
{
	public double makeSum(double x, double y) throws RemoteException;
	public double makeDif(double x, double y) throws RemoteException;
	public double makeProd(double x, double y) throws RemoteException;
	public double makeDiv(double x, double y) throws RemoteException;
	public double makeInverted(double x) throws RemoteException;
	public double makePower(double x, double y) throws RemoteException;
	public double makeFactorial(double x) throws RemoteException;
	public double makeSqrt(double x) throws RemoteException;
}