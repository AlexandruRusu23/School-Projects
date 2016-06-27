import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
import java.util.*;
import java.lang.*;

public class CalculatorServer 
{
	private static final String host = "localhost";

	public static void main(String[] args) throws Exception {

		CalculatorImplementation stub = new CalculatorImplementation();

		String object = "rmi://" + host + "/Calculator";

		Naming.rebind(object, stub);

		System.out.println("Ready to connect...");

		String input;
		String ext="exit";
		Scanner scan=new Scanner(System.in);
		input=scan.next();
		if(input.compareTo(ext)==0)
			System.exit(1);
	}
}
