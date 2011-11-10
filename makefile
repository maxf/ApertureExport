SAXON=java -jar saxon9he.jar 

photos.sh: first.xml secondPass.xsl
	$(SAXON) -s:first.xml -xsl:secondPass.xsl > photos.sh
	chmod u+x photos.sh

first.xml: ApertureData.xml firstPass.xsl
	$(SAXON) -s:ApertureData.xml -xsl:firstPass.xsl > first.xml
