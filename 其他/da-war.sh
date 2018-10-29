#!/bin/bash

cp ./tools/* ./

rm -rf jqreport test ok
unzip -q -o ./jqreport_s.war -d ./jqreport 
unzip -q -o ./da/*.da        -d ./test 

find ./test  -name "*jetty*"  | xargs rm -rf
find ./test  -name "javax.servlet*"  | xargs rm -rf

cp    ./test/*.info   ./jqreport/WEB-INF
cp -R ./test/dna/*    ./jqreport/WEB-INF/eclipse/plugins/dna/
cp -R ./test/lib/*    ./jqreport/WEB-INF/eclipse/plugins/dna/lib/
cp -R ./test/thr/*    ./jqreport/WEB-INF/eclipse/plugins/dna/thr/

for file in `ls ./test/app/`
do 
	unzip -q -o ./test/app/$file  -d ./jqreport/WEB-INF/eclipse/plugins/app/$file 
done

rm -f ./jqreport/WEB-INF/lib/com.jiuqi.dna.core.proxy.jar
cp ./com.jiuqi.dna.core.proxy_1.0.0.jar ./jqreport/WEB-INF/lib

rm -f ./jqreport/WEB-INF/eclipse/plugins/dna/bridge/com.jiuqi.dna.core.bridge_1.0.0.jar
cp ./com.jiuqi.dna.core.bridge_1.0.0.jar ./jqreport/WEB-INF/eclipse/plugins/dna/bridge

mv ./jqreport/META-INF ./META-INF
mv ./jqreport/WEB-INF  ./WEB-INF

mkdir ./ok
zip -q -r ./ok/snp.war ./META-INF ./WEB-INF

rm -rf ./jqreport ./test ./META-INF ./WEB-INF  ./*.jar ./*.war 

echo "已完成"
