<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <xsl:param name="resolution" select="'1280x800'"/>

  <xsl:param name="destDir" select="'photos'"/>

  <xsl:output method="text"/>

  <xsl:template match="/">

    <xsl:text>#!/bin/bash&#xa;</xsl:text>
    <!-- generate directories for albums -->
    <xsl:apply-templates select="plist/Application/ListOfAlbums/Album"/>

    <!-- resize and place photos -->
    <xsl:apply-templates select="plist/Application/MasterImageList/Photo"/>

    <!-- generate text list of all files created -->
    <xsl:result-document href="directories.txt" method="text">
      <xsl:apply-templates select="plist/Application/ListOfAlbums/Album" mode="list"/>
    </xsl:result-document>
    <xsl:result-document href="files.txt" method="text">
      <xsl:apply-templates select="plist/Application/MasterImageList/Photo" mode="list"/>
    </xsl:result-document>

  </xsl:template>

  <xsl:template match="Album" mode="path">
    <xsl:if test="@Parent">
      <xsl:apply-templates select="../Album[@AlbumId = current()/@Parent]" mode="path"/>
    </xsl:if>
    <xsl:value-of select="concat(AlbumName,'/')"/>
  </xsl:template>

  <xsl:template match="Album">
    <!-- find all ancestors -->
    <xsl:variable name="path">
      <xsl:apply-templates select="../Album[@AlbumId = current()/@Parent]" mode="path"/>
    </xsl:variable>
    <xsl:value-of select="concat('mkdir -p &quot;',$destDir,'/',$path,AlbumName,'&quot;&#xa;')"/>
  </xsl:template>

  <xsl:template match="Album" mode="list">
    <!-- find all ancestors -->
    <xsl:variable name="path">
      <xsl:apply-templates select="../Album[@AlbumId = current()/@Parent]" mode="path"/>
    </xsl:variable>
    <xsl:value-of select="concat($destDir,'/',$path,AlbumName,'&#xa;')"/>
  </xsl:template>

  <xsl:template match="Album" mode="fileName">
    <xsl:param name="key"/>
    <xsl:if test="@Parent">
      <xsl:apply-templates select="../Album[@AlbumId = current()/@Parent]" mode="path"/>
    </xsl:if>
    <xsl:value-of select="concat(AlbumName,'/')"/>
    <xsl:number value="1+count(KeyList/string[. = $key]/preceding-sibling::string)" format="00001"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="$key"/>
    <xsl:text>.jpg</xsl:text>
  </xsl:template>
  

  <xsl:template match="Photo[@MediaType='Image']">
    <xsl:variable name="dest">
      <xsl:value-of select="concat($destDir,'/')"/>
      <xsl:apply-templates select="/plist/Application/ListOfAlbums/Album[KeyList/string=current()/@key]" mode="fileName">
        <xsl:with-param name="key" select="@key"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:value-of select="concat('if [ &quot;',@image_path,'&quot; -nt &quot;',$dest,'&quot; ]&#xa;then&#xa;')"/>
    <xsl:value-of select="concat('  echo generating &quot;',$dest,'&quot;&#xa;')"/>
    <xsl:value-of select="concat('  cp &quot;',@image_path,'&quot; in.jpg&#xa;')"/>
<!--    <xsl:value-of select="concat('  convert -size ',$resolution,' in.jpg out.jpg&#xa;')"/> -->
<!--    <xsl:value-of select="concat('  mv out.jpg &quot;',$dest,'&quot;&#xa;')"/> -->
    <xsl:value-of select="concat('  mv in.jpg &quot;',$dest,'&quot;&#xa;')"/>
<!--    <xsl:value-of select="concat('else&#xa;  echo skipping ',@key,'&#xa;')"/>-->
    <xsl:value-of select="'fi&#xa;&#xa;'"/>
  </xsl:template>

  <xsl:template match="Photo[@MediaType='Image']" mode="list">
    <xsl:variable name="dest">
      <xsl:value-of select="concat($destDir,'/')"/>
      <xsl:apply-templates select="/plist/Application/ListOfAlbums/Album[KeyList/string=current()/@key]" mode="fileName">
        <xsl:with-param name="key" select="@key"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:value-of select="concat($dest,'&#xa;')"/>
  </xsl:template>

</xsl:transform>
