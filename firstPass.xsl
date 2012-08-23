<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="dict[key[.='Application Version']]">
    <Application 
        version="{key[.='Application Version']/following-sibling::string[1]}"
        archive_path="{key[.='Archive Path']/following-sibling::string[1]}"
        >
      <ListOfAlbums>
        <xsl:apply-templates select="key[.='List of Albums']/following-sibling::array[1]/*"/>
      </ListOfAlbums>
      <MasterImageList>
        <xsl:apply-templates select="key[.='Master Image List']/following-sibling::dict[1]/dict"/>
      </MasterImageList>
    </Application>
  </xsl:template>

  <xsl:template match="dict[key[.='ImagePath']]">
    <Photo 
        MediaType="{key[.='MediaType']/following-sibling::string[1]}"
        image_path="{key[.='ImagePath']/following-sibling::string[1]}"
        key="{preceding-sibling::key[1]}"
        ModDateAsTimerInterval="{key[.='ModDateAsTimerInterval']/following-sibling::string[1]}"
        >
    </Photo>
  </xsl:template>



  <xsl:template match="dict[key[.='AlbumId']]">
    <xsl:variable name="AlbumType" select="key[.='Album Type']/following-sibling::string[1]"/>
    <xsl:variable name="AlbumName" select="key[.='AlbumName']/following-sibling::string[1]"/>
    <xsl:if test="$AlbumType=4 or $AlbumType=6">
      <Album 
        AlbumId="{key[.='AlbumId']/following-sibling::integer[1]}"
        ProjectEarliestDateAsTimerInterval="{key[.='ProjectEarliestDateAsTimerInterval']/following-sibling::real[1]}"
        >
        <xsl:if test="key[.='Parent']">
          <xsl:variable name="Parent" select="key[.='Parent']/following-sibling::integer[1]"/>
          <xsl:if test="not($Parent=3)">
            <xsl:attribute name="Parent" select="$Parent"/>
          </xsl:if>
        </xsl:if>

        <AlbumName>
          <xsl:value-of select="key[.='AlbumName']/following-sibling::string[1]"/>
        </AlbumName>
        <xsl:if test="key[.='KeyList']">
          <KeyList><xsl:apply-templates select="key[.='KeyList']/following-sibling::array[1]/string"/></KeyList>
        </xsl:if>
      </Album>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
