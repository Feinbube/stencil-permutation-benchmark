g++ -O3 -o main-c main.cpp
nim c -d:release --opt:speed --out:main-nim main.nim
nim js -d:nodejs -d:release --opt:speed --out:main-nim.js main.nim
coffee -cs < main.coffee > main-coffee.js

echo ""
echo ""
echo "c++ with O3"
echo "###########"
time ./main-c

echo ""
echo ""
echo "nim-c with opt:speed"
echo "####################"
time ./main-nim

echo ""
echo ""
echo "node"
echo "####"
time node main.js

echo ""
echo ""
echo "coffee"
echo "######"
time node main-coffee.js

echo ""
echo ""
echo "nim-js with opt:speed"
echo "#####################"
time node main-nim.js

echo ""
echo ""
echo "pypy with O"
echo "###########"
time pypy -O main.py

echo ""
echo ""
echo "python3"
echo "#######"
time python3 main.py