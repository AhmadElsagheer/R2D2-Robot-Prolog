import java.util.ArrayList;
import java.util.Scanner;

// Input: an integer n followed by n space-separated actions (north/east/south/west)
// Output: a situation
public class GenActionSequence {

	public static void main(String[] args) throws Exception {

		Scanner sc = new Scanner(System.in);

		int n = sc.nextInt();
		ArrayList<String> arr = new ArrayList<>();
		while(n-->0)
			arr.add(sc.next());
		String ans = "s0";
		for(String x: arr)
			ans = "result(" + x + "," + ans+")";
		System.out.println(ans);
	}
}