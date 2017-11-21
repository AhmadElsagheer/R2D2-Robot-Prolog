import java.io.*;
import java.util.*;

// Input: file name and grid dimensions
// Output: pl file with R2D2 Problem logical sentences
public class GenGrid {

	private static PrintWriter out;

	public static void main(String[] args) throws Exception {

		Scanner sc = new Scanner(System.in);

		System.out.println("Enter output file name: ");
		String fileName = sc.next() + ".pl";

		out = new PrintWriter(fileName);

		System.out.println("Enter grid dimensions: ");
		int R = sc.nextInt(), C = sc.nextInt();
		initializeGrid(R, C);
		printGrid();
		out.close();
		System.out.println("Output file generated successfully");
	}


	private static char[][] grid;
	private static int N, M;
	private static final char ROBOT = 'R', TELEPORT = 'T', EMPTY_CELL = '.';
	private static final char OBSTACLE = '#', ROCK = 'O', PRESSURE_PAD = 'P';


	private static void initializeGrid(int R, int C)
	{
		N = R; M = C;
		int n = N - 2, m = M - 2;
		grid = new char[N][M];
		for(char[] row: grid)
			Arrays.fill(row, EMPTY_CELL);
		Random rand = new Random();
		int numberOfRocks = rand.nextInt((n * m - 2) / 2 + 1);
		int numberOfObstacles = rand.nextInt(Math.min(n * m - 2 - numberOfRocks * 2 + 1, Math.max(n, m)));
		int[] positions = new int[n * m];
		for (int i = 0; i < n * m; ++i)
			positions[i] = i;
		shuffle(positions, rand);
		char[] symbols = { ROBOT, TELEPORT, ROCK, PRESSURE_PAD, OBSTACLE };
		int[] sizes = { 1, 1, numberOfRocks, numberOfRocks, numberOfObstacles };
		for (int i = 0, start = 0; i < symbols.length; ++i)
			setPositions(positions, start, start += sizes[i], symbols[i]);
	}

	private static void shuffle(int[] positions, Random rand) {
		for (int i = 0; i < positions.length; ++i) {
			int j = rand.nextInt(positions.length - i) + i;
			int tmp = positions[i];
			positions[i] = positions[j];
			positions[j] = tmp;
		}
	}

	private static void setPosition(int position, char symbol) {
		grid[position / (M - 2) + 1][position % (M - 2) + 1] = symbol;
	}

	private static void setPositions(int[] positions, int start, int end, char symbol) {
		for (int i = start; i < end; ++i)
			setPosition(positions[i], symbol);
	}

	private static void printGrid() {

//		1. Print Header
		out.print("% =========================================================================== %\n" +
				"%                               Grid Representation                           %\n" +
				"% =========================================================================== %\n" +
				"\n");

//		2. Print Grid Representation
		StringBuilder ret = new StringBuilder();
		for (int i = 0; i < N; ++i) {
			ret.append("% ").append(grid[i]).append("\n");
		}
		out.println(ret);

//		3. Print Grid Dimensions
		out.print("% Grid Dimensions\n");
		out.printf("grid_size(%d, %d).\n\n", N, M);

		String title[] = {"R2D2 initial Location", "Teleport Location", "Rocks Locations",
				"Pressure Pad Locations", "Obstacles Locations"};
		String format[] = {"r2d2_init_location", "teleport", "rock_location", "pressure_pad", "obstacle"};
		char[] sym = {'R', 'T', 'O', 'P', '#'};
//		4. Print R2D2 locations
		for(int i = 0; i < title.length; ++i)
		{
			out.println("% " + title[i]);
			printLocations(format[i], sym[i]);
			out.println();
		}
	}

	private static void printLocations(String format, char sym)
	{
		for(int i = 0; i < N; ++i)
			for(int j = 0; j < M; ++j)
				if(grid[i][j] == sym)
					out.printf("%s(location(%d, %d)).\n", format, i + 1, j + 1);
		if(sym == 'O' || sym == 'P')
			out.printf("%s(location(%d, %d)).   %c dummy\n", format, N + 1, M + 1, '%');
		else if(sym == '#')
			out.printf("%s(location(%d, %d)).   %c dummy\n", format, N + 2, M + 2, '%');
	}
}