#include <stdlib.h>
#include <iostream>

#define w 4
#define processorCount 4

int** createField() {
	int** field2D = (int**)malloc(w * sizeof(int*));
	int cellsPerProcessor = (int)((w * w) / processorCount);
	for (int y = 0; y < w; y++) {
		field2D[y] = (int*)malloc(w * sizeof(int));
		for (int x = 0; x < w; x++) {
			field2D[y][x] = std::min(processorCount -1, (int)((y * w + x) / cellsPerProcessor));
		}
	}
	return field2D;
}

int rank(int** field2D) {
	int sum = 0;
	for (int y = 0; y < w; y++) {
		for (int x = 0; x < w; x++) {
			int v = field2D[y][x];

			int y2 = y <= 0 ? 0 : y - 1;
			int y3 = y >= w - 1 ? w - 1 : y + 1;
			int x4 = x <= 0 ? 0 : x - 1;
			int x5 = x >= w - 1 ? w - 1 : x + 1;

			if (v != field2D[y2][x]) sum++;
			if (v != field2D[y3][x]) sum++;
			if (v != field2D[y][x4]) sum++;
			if (v != field2D[y][x5]) sum++;
		}
	}
	return sum;
}

void printField(int** field2D) {
	for (int y = 0; y < w; y++) {
		for (int x = 0; x < w; x++) {
			std::cout << field2D[y][x] << " ";
		}
		std::cout << std::endl;
	}
	std::cout << "rank: " << rank(field2D) << std::endl;
}

int at(int** field2D, int x, int y) {
	if ((x < 0 && y < 0) || (x >= w && y >= w)) {
		throw "out of bounds";
	}
	while (x < 0) { x += w; y--; }
	while (x >= w) { x -= w; y++; }
	if (y < 0 || y >= w) {
		throw "out of bounds";
	}
	return field2D[y][x];
}

int setAt(int** field2D, int x, int y, int v) {
	if ((x < 0 && y < 0) || (x >= w && y >= w)) {
		throw "out of bounds";
	}
	while (x < 0) { x += w; y--; }
	while (x >= w) { x -= w; y++; }
	if (y < 0 || y >= w) {
		throw "out of bounds";
	}
	field2D[y][x] = v;
}

void swap(int** field2D, int x1, int y1, int x2, int y2) {
	int tmp = at(field2D, x2, y2);
	setAt(field2D, x2, y2, at(field2D, x1 - 1, y1));
	setAt(field2D, x1 - 1, y1, tmp);
}

bool nextPermutation(int** field2D) {

	// Find non - increasing suffix
	int x1 = w - 1;
	int y1 = w - 1;
	while ((x1 > 0 || y1 > 0) && at(field2D, x1 - 1, y1) >= at(field2D, x1, y1)) {
		x1--;
		if (x1 < 0) {
			x1 += w;
			y1--;
		}
	}
	if (x1 <= 0 && y1 <= 0) {
		return false;
	}

	// Find successor to pivot
	int x2 = w - 1;
	int y2 = w - 1;
	int pivot = at(field2D, x1 - 1, y1);
	while (field2D[y2][x2] <= pivot) {
		x2--;
		if (x2 < 0) {
			x2 += w;
			y2--;
		}
	}

	// Swap elements
	swap(field2D, x1, y1, x2, y2);

	// Reverse suffix
	x1++;
	if (x1 >= w) {
		x1 -= w;
		y1++;
	}
	x2 = w - 1;
	y2 = w - 1;
	while (y2 > y1 || (y2 == y1 && x2 >= x1)) { // equal to y2 * w + x2 >= y1 * w + x1
		swap(field2D, x1, y1, x2, y2);
		x1++;
		if (x1 >= w) {
			x1 -= w;
			y1++;
		}
		x2--;
		if (x2 < 0) {
			x2 += w;
			y2--;
		}
	}

	return true;
}

int main() {
	int** field2D = createField();
	int count = 0;
	int bestRank = rank(field2D);

	while (nextPermutation(field2D)) {
		if (field2D[0][0] != 0) {
			break;
		}
		count++;

		int newRank = rank(field2D);
		if (newRank < bestRank) {
			bestRank = newRank;
			printField(field2D);
		}
	}

	std::cout << "count: " << count << std::endl;
	std::cout << "best rank: " << bestRank << std::endl;
	return 0;
}





