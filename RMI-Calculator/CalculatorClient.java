import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
import java.util.*;
import java.lang.*;

public class CalculatorClient 
{
	private static final String host = "localhost";
	public static void main(String args[]) 
	{
		Scanner scan = new Scanner(System.in);
		try 
		{
			Calculator stub = (Calculator) Naming.lookup("rmi://" + host + "/Calculator");
         
			Double a=0.0,b=0.0;
			Double result=0.0;
			String option;
			int ok=0;
			while(true)
			{
				System.out.println(" _____________________\n|"+result+"\n ~~~~~~~~~~~~~~~~~~~~~");
				option=scan.next();
				switch(option)
				{
					case "+":
					option = scan.next();
					if(option.matches("-?\\d+(\\.\\d+)?"))
					{
						a=a.valueOf(option);
						result = stub.makeSum(result,a);
					}
					break;
				        		
					case "-":
					option = scan.next();
					if(option.matches("-?\\d+(\\.\\d+)?"))
					{
						a=a.valueOf(option);
						result = stub.makeDif(result,a);
					}
					break;
					case "*":
					option = scan.next();
					if(option.matches("-?\\d+(\\.\\d+)?"))
					{
						a=a.valueOf(option);
						result = stub.makeProd(result,a);
					}
					break;
					case "/":
					option = scan.next();
					if(option.matches("-?\\d+(\\.\\d+)?"))
					{
						a=a.valueOf(option);
						result = stub.makeDiv(result,a);
					}
					break;

					//ridicare la putere
					case "^":
					option = scan.next();
					if(option.matches("-?\\d+(\\.\\d+)?"))
					{
						a=a.valueOf(option);
						result = stub.makePower(result,a);
					}
					break;
					//radical
					case "sqrt":
						result = stub.makeSqrt(result);
					break;

					//factorial
					case "!":
						if(Math.floor(result)==result)
						{
							if(result>=0)
								result = stub.makeFactorial(result);
							else
								System.out.println("Not a natural number!");
						}
						else
							System.out.println("Not a natural number!");
					break;

					//invers
					case "_":
						result = stub.makeInverted(result);
					break;
					case "exit":
						System.exit(1);
					break;
					default:
						if(option.matches("-?\\d+(\\.\\d+)?"))
						{
							a=a.valueOf(option);
							result = a;
						}
				}
			}
		} 
		catch (ConnectException e) 
		{
			System.out.println("Ooops! ... Can't connect to server!");
			System.exit(1);
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			System.exit(1);
		}
	}
}
