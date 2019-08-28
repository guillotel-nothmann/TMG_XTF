<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf">
  <xsl:import href="parameter.xsl" />
  <xsl:key match="//*:ref" name="index" use="@target" />
  <xsl:key match="//*:ref" name="index1" use="@subtype" />
  <xsl:key match="//*:quote" name="quote" use="substring(@corresp, 2)" />
  <xsl:variable name="entry" select="document(concat($index.path, '/index.xml'))//*[*:listPerson | *:listPlace | *:list[@type = 'gloss'] | *:listBibl[@type = 'bibl_other']]" />
  <xsl:variable name="quote" select="//*:quote/@corresp" />
  <xsl:variable name="root" select="/" />
  <xsl:variable name="content.href"><xsl:value-of select="$query.string" />&#038;doc.view=content&#038;chunk.id=<xsl:value-of select="$chunk.id" />&#038;toc.depth=<xsl:value-of select="$toc.depth" />&#038;brand=<xsl:value-of select="$brand" />&#038;anchor.id=<xsl:value-of select="$anchor.id" /><xsl:value-of select="$search" /></xsl:variable>
  <xsl:template name="status">
    <pre>
      <!--<xsl:value-of select="$entry" />-->
    </pre>
    <h2>Edition status
      <!--<xsl:variable name="red">
        <xsl:choose>
          <xsl:when test="//*:editorialDecl//*:item/@n='transcription'">
            <xsl:value-of>true</xsl:value-of>
          </xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="orange">
        <xsl:choose>
          <xsl:when
            test="//*:editorialDecl//*:item/@n='typoAbb' and //*:editorialDecl//*:item/@n='hyphen'">
            <xsl:value-of>true</xsl:value-of>
          </xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="yellow">
        <xsl:choose>
          <xsl:when
            test="//*:editorialDecl//*:item/@n='div' and //*:editorialDecl//*:item/@n='tables' and //*:editorialDecl//*:item/@n='music'">
            <xsl:value-of>true</xsl:value-of>
          </xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="green">
        <xsl:choose>
          <xsl:when
            test=" //*:editorialDecl//*:item/@n='addDelCorr' and //*:editorialDecl//*:item/@n='pPWM' and //*:editorialDecl//*:item/@n='citations'">
            <xsl:value-of>true</xsl:value-of>
          </xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$green = 'true' and $yellow = 'true' and $orange = 'true' and $red = 'true'">
          <img src="{$icon.path}bullet-green.png" align="top"/>
        </xsl:when>
        <xsl:when test="$yellow = 'true' and $orange = 'true' and $red = 'true'">
          <img src="{$icon.path}bullet-yellow.png" align="top"/>
        </xsl:when>
        <xsl:when test="$orange = 'true' and $red = 'true'">
          <img src="{$icon.path}bullet-orange.png" align="top"/>
        </xsl:when>
        <xsl:when test="$red = 'true'">
          <img src="{$icon.path}bullet-red.png" align="top"/>
        </xsl:when>
        <xsl:otherwise>
          <img src="{$icon.path}bullet-red.png" align="top"/>
        </xsl:otherwise> </xsl:choose>-->
    </h2>
    <table border="0" width="75%">
      <tr>
        <td />
        <td>
          <img align="top" src="{$icon.path}text.png" title="Plain text" />
        </td>
        <xsl:if test="//*:editorialDecl//*:item/@n = 'div'">
          <td>
            <img align="top" src="{$icon.path}structure.png" title="Text hierarchy" />
          </td>
        </xsl:if>
        <xsl:if test="//*:editorialDecl//*:item/@n = 'typoAbb'">
          <td>
            <img align="top" src="{$icon.path}N.png" title="Normalization of typography and resolution of abbreviations" />
          </td>
        </xsl:if>
        <xsl:if test="//*:editorialDecl//*:item/@n = 'addDelCorr'">
          <td>
            <img align="top" src="{$icon.path}correct.png" title="Addidtions, Deletions, Corrections" />
          </td>
        </xsl:if>
        <xsl:if test="//*:editorialDecl//*:item/@n = 'music'">
          <td>
            <img align="top" src="{$icon.path}music.png" title="Musical examples" />
          </td>
        </xsl:if>
        <xsl:if test="//*:editorialDecl//*:item/@n = 'pPWM'">
          <td>
            <img align="top" src="{$icon.path}ppwt.png" title="Persons, places, works and musical terminology" />
          </td>
        </xsl:if>
        <xsl:if test="//*:editorialDecl//*:item/@n = 'citations'">
          <td>
            <img align="top" src="{$icon.path}citation.png" title="Citations" />
          </td>
        </xsl:if>
      </tr>
    </table>
  </xsl:template>
  <xsl:template name="indices">
    <xsl:call-template name="spoiler" />
    <xsl:if test="//*:editorialDecl//*:item/@n = 'pPWM'">
      <hr />
      <h2>Indices</h2>
      <xsl:call-template name="generalis" />
    </xsl:if>
    <xsl:if test="//*:editorialDecl//*:item/@n = 'citations'">
      <xsl:call-template name="exempla" />
    </xsl:if>
    <xsl:if test="//*:editorialDecl//*:item/@n = 'pPWM'">
      <xsl:call-template name="thesaurus" />
    </xsl:if>
  </xsl:template>
  <xsl:template name="spoiler">
    <!-- script for hiding indexes -->
    <script type="text/javascript">
      var imgPath = '<xsl:value-of select="$icon.path" />';
      function ouvrirFermerSpoiler(div)
      {
          var divContenu = document.getElementById(div);
          if(divContenu.style.display == 'block')
              divContenu.style.display = 'none' ;
          else
              divContenu.style.display = 'block'  ;       
      } 
      function changeimg(monimage) {
      monimage.src = (monimage.src==imgPath+"i_colpse.gif") ? imgPath+"i_expand.gif" : imgPath+"i_colpse.gif";
      }
    </script>
  </xsl:template>
  <xsl:template name="generalis">
    <!-- Create INDEX GENERALIS -->
    <h3>
      <span class="spoilerDiv" onclick="ouvrirFermerSpoiler('generalis')">
        <img onclick="changeimg(this)" src="{$icon.path}i_expand.gif" />
      </span>
      <xsl:choose>
        <xsl:when test="//*:editorialDecl//*:item/@n = 'generalis'">
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="//*:editorialDecl//*:item[@n = 'generalis']/*:ptr/@target" />
            </xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:attribute name="style">color:brown; text-decoration: none</xsl:attribute>
            <xsl:value-of> Index Generalis</xsl:value-of>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of> Index Generalis</xsl:value-of>
        </xsl:otherwise>
      </xsl:choose>
    </h3>
    <div id="generalis" style="display: none">
      <xsl:for-each select="$entry/*/*[parent::*:listPerson | parent::*:listPlace | parent::*:listBibl]">
        <xsl:sort data-type="text" order="ascending" select="@xml:id" />
        <xsl:variable name="XMLID" select="@xml:id" />
        <!-- check if XMLID is included in one of the references of the main doc (needed for references of level2)-->
        <xsl:variable name="xmlExists">
          <xsl:for-each select="$root">
            <xsl:if test="//*[contains(@ref, concat('#', $XMLID))]">true</xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$xmlExists = 'true'">
          <hr />
          <!-- Level I -->
          <table border="0" cellpadding="0" cellspacing="0" class="title">
            <tr>
              <td width="5" />
              <td>
                <!-- persons -->
                <xsl:if test="self::*:person">
                  <a style="color:brown; text-decoration: none">
                    <!-- create Path -->
                    <xsl:call-template name="createPath">
                      <xsl:with-param name="pXMLID" select="$XMLID" />
                    </xsl:call-template>
                    <!-- get name -->
                    <xsl:call-template name="name" />
                  </a>
                </xsl:if>
                <xsl:if test="self::*:personGrp">
                  <a style="color:brown; text-decoration: none">
                    <!-- create Path -->
                    <xsl:call-template name="createPath">
                      <xsl:with-param name="pXMLID" select="$XMLID" />
                    </xsl:call-template>
                    <!-- get name -->
                    <xsl:call-template name="name" />
                  </a>
                </xsl:if>
                <!-- places -->
                <xsl:if test="self::*:place">
                  <a style="color:brown; text-decoration: none">
                    <xsl:call-template name="createPath">
                      <xsl:with-param name="pXMLID" select="$XMLID" />
                    </xsl:call-template>
                    <xsl:value-of select="*:placeName/text()" />
                  </a>
                </xsl:if>
                <!-- collective works -->
                <xsl:if test="self::*:bibl">
                  <a style="color:brown; text-decoration: none">
                    <xsl:call-template name="createPath">
                      <xsl:with-param name="pXMLID" select="$XMLID" />
                    </xsl:call-template>
                    <xsl:value-of select="*:title" />
                  </a>
                </xsl:if>
                <xsl:call-template name="rowForOccurrence">
                  <xsl:with-param name="pXMLID" select="$XMLID" />
                </xsl:call-template>
              </td>
            </tr>
          </table>
          <!-- Level II -->
          <table border="0">
            <xsl:for-each select="*:bibl">
              <!-- référence bibliorgaphique -->
              <xsl:if test="@xml:id">
                <xsl:variable name="XMLID" select="@xml:id" />
                <!-- check if level II ref exists -->
                <xsl:variable name="xmlExists">
                  <xsl:for-each select="$root">
                    <xsl:if test="//*[contains(@ref, concat('#', $XMLID))]">true</xsl:if>
                  </xsl:for-each>
                </xsl:variable>
                <xsl:if test="$xmlExists = 'true'">
                  <tr>
                    <td width="20" />
                    <td>
                      <li>
                        <xsl:call-template name="createBiblioReference" />
                      </li>
                    </td>
                  </tr>
                  <tr>
                    <td />
                    <td>
                      <!-- occurrences in main doc -->
                      <xsl:for-each select="$root">
                        <xsl:for-each select="key('index', $XMLID)">
                          <xsl:call-template name="createLinkToOccurrence" />
                        </xsl:for-each>
                      </xsl:for-each>
                      <xsl:for-each select="*:biblScope">
                        <!-- get precise location in source -->
                        <xsl:variable name="XMLID" select="@xml:id" />
                        <!-- check if entry exists -->
                        <xsl:variable name="p" select="text()" />
                        <xsl:variable name="type">
                          <xsl:call-template name="biblType" />
                        </xsl:variable>
                        <xsl:variable name="loc">
                          <xsl:value-of select="concat($type, $p, ' ')" />
                        </xsl:variable>
                        <xsl:variable name="link">
                          <xsl:call-template name="biblLink" />
                        </xsl:variable>
                        <!-- back to main doc -->
                        <xsl:for-each select="$root">
                          <xsl:for-each select="key('index', $XMLID)">
                            <!-- create arrow and indicate location in doc-->
                            <xsl:call-template name="createLinkToOccurrence" />
                            <xsl:text> → </xsl:text>
                            <!-- value of source location -->
                            <xsl:choose>
                              <xsl:when test="$link = 'X'">
                                <xsl:value-of select="$loc" />
                              </xsl:when>
                              <xsl:otherwise>
                                <a href="{$link}" style="color:brown; text-decoration: none" target="_blank">
                                  <xsl:value-of select="$loc" />
                                </a>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:for-each>
                        </xsl:for-each>
                      </xsl:for-each>
                    </td>
                  </tr>
                </xsl:if>
              </xsl:if>
            </xsl:for-each>
          </table>
        </xsl:if>
      </xsl:for-each>
    </div>
  </xsl:template>
  <xsl:template name="exempla">
    <!-- Exempla -->
    <h3>
      <span class="spoilerDiv" onclick="ouvrirFermerSpoiler('exempla')">
        <img onclick="changeimg(this)" src="{$icon.path}i_expand.gif" />
      </span>
      <xsl:choose>
        <xsl:when test="//*:editorialDecl//*:item/@n = 'exempla'">
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="//*:editorialDecl//*:item[@n = 'exempla']/*:ptr/@target" />
            </xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:attribute name="style">color:brown; text-decoration: none</xsl:attribute>
            <xsl:value-of> Exempla</xsl:value-of>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of> Exempla</xsl:value-of>
        </xsl:otherwise>
      </xsl:choose>
    </h3>
    <div id="exempla" style="display: none">
      <xsl:for-each select="$entry/*/*[parent::*:listPerson | parent::*:listBibl]">
        <xsl:sort data-type="text" order="ascending" select="@xml:id" />
        <xsl:variable name="XMLID" select="@xml:id" />
        <!-- check if XMLID is included in one of the references of the main doc (needed for references of level2)-->
        <xsl:variable name="xmlExists">
          <xsl:for-each select="$root">
            <xsl:if test="//*[contains(@corresp, concat('#', $XMLID))]">true</xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test="*:bibl/*:biblScope">
          <xsl:if test="$xmlExists = 'true'">
            <b>
              <table border="0">
                <tr>
                  <td width="5" />
                  <td>
                    <xsl:if test="parent::*:listPerson">
                      <a style="color:brown; text-decoration: none">
                        <xsl:call-template name="createPath">
                          <xsl:with-param name="pXMLID" select="@xml:id" />
                        </xsl:call-template>
                        <xsl:call-template name="name" />
                      </a>
                    </xsl:if>
                    <xsl:if test="parent::*:listBibl">
                      <a style="color:brown; text-decoration: none">
                        <xsl:call-template name="createPath">
                          <xsl:with-param name="pXMLID" select="@xml:id" />
                        </xsl:call-template>
                        <xsl:value-of select="*:title" />
                      </a>
                    </xsl:if>
                  </td>
                </tr>
              </table>
            </b>
            <xsl:for-each select="*:bibl[*:biblScope]">
              <xsl:variable name="XMLID" select="@xml:id" />
              <xsl:variable name="xmlExists">
                <xsl:for-each select="$root">
                  <xsl:if test="//*[contains(@corresp, concat('#', $XMLID))]">true</xsl:if>
                </xsl:for-each>
              </xsl:variable>
              <xsl:if test="$xmlExists = 'true'">
                <table border="0">
                  <tr>
                    <td width="20" />
                    <td>
                      <li>
                        <a style="color:brown; text-decoration: none">
                          <xsl:call-template name="createExternalPath">
                            <xsl:with-param name="pXMLID" select="*:link/@facs" />
                          </xsl:call-template>
                          <xsl:call-template name="createBiblioReference" />
                        </a>
                      </li>
                    </td>
                  </tr>
                  <tr>
                    <td />
                    <td>
                      <xsl:for-each select="*:biblScope">
                        <xsl:variable name="XMLID" select="@xml:id" />
                        <xsl:choose>
                          <xsl:when test="@type = 'pp' or @type = 'lib' or @type = 'cap' or @type = 'fol' or @type = 'num' or @type = 'll'">
                            <xsl:variable name="p" select="text()" />
                            <xsl:variable name="type">
                              <xsl:call-template name="biblType" />
                            </xsl:variable>
                            <xsl:variable name="loc">
                              <xsl:choose>
                                <xsl:when test="@type = 'fol'">
                                  <xsl:value-of select="concat($type, $p, ' ')" />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of select="concat($type, $p, '. ')" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="link">
                              <xsl:choose>
                                <xsl:when test="*:link/@facs">
                                  <xsl:value-of select="*:link/@facs" />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of select="'X'" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:variable>
                            <xsl:for-each select="$root">
                              <!-- retour au document principal -->
                              <xsl:for-each select="key('quote', $XMLID)">
                                <xsl:if test="substring(@corresp, 2)">
                                  <xsl:variable name="refchunk">
                                    <xsl:choose>
                                      <xsl:when test="ancestor::*:div4">
                                        <xsl:value-of select="ancestor::*:div4/@xml:id" />
                                      </xsl:when>
                                      <xsl:when test="ancestor::*:div3">
                                        <xsl:value-of select="ancestor::*:div3/@xml:id" />
                                      </xsl:when>
                                      <xsl:when test="ancestor::*:div2">
                                        <xsl:value-of select="ancestor::*:div2/@xml:id" />
                                      </xsl:when>
                                      <xsl:when test="ancestor::*:div1">
                                        <xsl:value-of select="ancestor::*:div1/@xml:id" />
                                      </xsl:when>
                                    </xsl:choose>
                                  </xsl:variable>
                                  <xsl:variable name="corresp" select="substring(@corresp, 2)" />
                                  <xsl:variable name="anchor" select="preceding::*:pb[1]/@xml:id" />
                                  <xsl:variable name="refchunk" select="ancestor::*:div1/@xml:id" />
                                  <!-- l'ancre n'est pas sur la page chargée -->
                                  <a target="content">
                                    <xsl:attribute name="href">
                                      <xsl:value-of select="$doc.path" />&#038;doc.view=content&#038;chunk.id=<xsl:value-of select="$refchunk" />&#038;toc.depth=<xsl:value-of select="$toc.depth" />&#038;brand=<xsl:value-of select="$brand" />&amp;#<xsl:value-of select="$anchor" /></xsl:attribute>
                                    <img alt="arrow" border="0" height="10" src="{$icon.path}arrow.gif" width="14" />
                                  </a>
                                  <xsl:choose>
                                    <xsl:when test="preceding::*:pb[position() = 1]/@n">
                                      <xsl:value-of select="preceding::*:pb[position() = 1]/@n" />
                                    </xsl:when>
                                    <xsl:otherwise>[i]</xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:text> → </xsl:text>
                                  <xsl:choose>
                                    <xsl:when test="$link = 'X'">
                                      <xsl:value-of select="$loc" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <a href="{$link}" style="color:brown; text-decoration: none" target="_blank">
                                        <xsl:value-of select="$loc" />
                                      </a>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:if>
                              </xsl:for-each>
                            </xsl:for-each>
                          </xsl:when>
                        </xsl:choose>
                      </xsl:for-each>
                    </td>
                  </tr>
                </table>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
    </div>
  </xsl:template>
  <xsl:template name="thesaurus">
    <!-- Thesaurus -->
    <h3>
      <span class="spoilerDiv" onclick="ouvrirFermerSpoiler('thesaurus')">
        <img onclick="changeimg(this)" src="{$icon.path}i_expand.gif" />
      </span>
      <xsl:choose>
        <xsl:when test="//*:editorialDecl//*:item/@n = 'thesaurus'">
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="//*:editorialDecl//*:item[@n = 'thesaurus']/*:ptr/@target" />
            </xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:attribute name="style">color:brown; text-decoration: none</xsl:attribute>
            <xsl:value-of> Thesaurus</xsl:value-of>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of> Thesaurus</xsl:value-of>
        </xsl:otherwise>
      </xsl:choose>
    </h3>
    <div id="thesaurus" style="display: none">
      <xsl:for-each select="$entry/*/*[parent::*:list]">
        <xsl:sort data-type="text" order="ascending" select="@xml:id" />
        <xsl:variable name="XMLID" select="@xml:id" />
        <xsl:variable name="xmlExists">
          <xsl:for-each select="$root">
            <xsl:if test="//*[contains(@ref, concat('#', $XMLID))]">true</xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$xmlExists = 'true'">
          <table border="0">
            <tr>
              <td width="5" />
              <td>
                <b>
                  <a style="color:brown; text-decoration: none">
                    <!-- create Path -->
                    <xsl:call-template name="createPath">
                      <xsl:with-param name="pXMLID" select="$XMLID" />
                    </xsl:call-template>
                    <!-- get name -->
                    <xsl:value-of select="*:title" />
                    <!-- <xsl:call-template name="name"/>-->
                  </a>
                </b>
              </td>
            </tr>
            <tr>
              <td width="5" />
              <td>
                <xsl:for-each select="$root">
                  <xsl:for-each select="key('index', $XMLID)">
                    <xsl:if test="not(contains(@type, 'work'))">
                      <xsl:variable name="refchunk">
                        <xsl:choose>
                          <xsl:when test="ancestor::*:div4">
                            <xsl:value-of select="ancestor::*:div4/@xml:id" />
                          </xsl:when>
                          <xsl:when test="ancestor::*:div3">
                            <xsl:value-of select="ancestor::*:div3/@xml:id" />
                          </xsl:when>
                          <xsl:when test="ancestor::*:div2">
                            <xsl:value-of select="ancestor::*:div2/@xml:id" />
                          </xsl:when>
                          <xsl:when test="ancestor::*:div1">
                            <xsl:value-of select="ancestor::*:div1/@xml:id" />
                          </xsl:when>
                        </xsl:choose>
                      </xsl:variable>
                      <xsl:variable name="target" select="@target" />
                      <xsl:variable name="anchor" select="preceding::*:pb[1]/@xml:id" />
                      <xsl:variable name="refchunk" select="ancestor::*:div1/@xml:id" />
                      <!-- l'ancre n'est pas sur la page chargée -->
                      <a target="content">
                        <xsl:attribute name="href">
                          <xsl:value-of select="$doc.path" />&#038;doc.view=content&#038;chunk.id=<xsl:value-of select="$refchunk" />&#038;toc.depth=<xsl:value-of select="$toc.depth" />&#038;brand=<xsl:value-of select="$brand" />&amp;#<xsl:value-of select="$anchor" /></xsl:attribute>
                        <img alt="arrow" border="0" height="10" src="{$icon.path}arrow.gif" width="14" />
                      </a>
                      <xsl:choose>
                        <xsl:when test="preceding::*:pb[position() = 1]/@n">
                          <xsl:value-of select="preceding::*:pb[position() = 1]/@n" />
                        </xsl:when>
                        <xsl:otherwise>[i]</xsl:otherwise>
                      </xsl:choose>
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:for-each>
              </td>
            </tr>
          </table>
        </xsl:if>
      </xsl:for-each>
    </div>
  </xsl:template>
  <xsl:template exclude-result-prefixes="#all" name="localentry">
    <html lang="en" xml:lang="en">
      <head>
        <link href="icons/default/favicon.ico" rel="shortcut icon" />
        <title>
          <xsl:text>Eintrag </xsl:text>
          <xsl:value-of select="$chunk.id" />
        </title>
      </head>
      <body>
        <xsl:for-each select="$entry[@xml:id = $chunk.id]">
          <xsl:apply-templates />
        </xsl:for-each>
        <div class="index">
          <h3>Index</h3>
          <xsl:for-each select="$root">
            <xsl:for-each select="key('index', $chunk.id)">
              <xsl:if test="not(contains(@type, 'work'))">
                <xsl:variable name="refchunk">
                  <xsl:choose>
                    <xsl:when test="ancestor::*:div4">
                      <xsl:value-of select="ancestor::*:div4/@xml:id" />
                    </xsl:when>
                    <xsl:when test="ancestor::*:div3">
                      <xsl:value-of select="ancestor::*:div3/@xml:id" />
                    </xsl:when>
                    <xsl:when test="ancestor::*:div2">
                      <xsl:value-of select="ancestor::*:div2/@xml:id" />
                    </xsl:when>
                    <xsl:when test="ancestor::*:div1">
                      <xsl:value-of select="ancestor::*:div1/@xml:id" />
                    </xsl:when>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="target" select="@target" />
                <xsl:variable name="anchor" select="preceding::*:pb[1]/@xml:id" />
                <xsl:variable name="refchunk" select="ancestor::*:div1/@xml:id" />
                <!-- l'ancre n'est pas sur la page chargée -->
                <a target="content">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$doc.path" />&#038;doc.view=content&#038;chunk.id=<xsl:value-of select="$refchunk" />&#038;toc.depth=<xsl:value-of select="$toc.depth" />&#038;brand=<xsl:value-of select="$brand" />&#038;anchor.id=<xsl:value-of select="$anchor" />&#038;<xsl:call-template name="create.anchor" /></xsl:attribute>
                  <xsl:if test="$anchor.id = $anchor">
                    <xsl:attribute name="id">
                      <xsl:value-of select="$anchor" />
                    </xsl:attribute>
                  </xsl:if>
                  <img alt="arrow" border="0" height="10" src="{$icon.path}arrow.gif" width="14" />
                </a>
                <xsl:choose>
                  <xsl:when test="preceding::*:pb[position() = 1]/@n">
                    <xsl:value-of select="preceding::*:pb[position() = 1]/@n" />
                  </xsl:when>
                  <xsl:otherwise>[i]</xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each>
        </div>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="name">
    <xsl:choose>
      <xsl:when test="*:persName/*:surname">
        <xsl:value-of select="*:persName/*:surname" />
        <xsl:value-of>, </xsl:value-of>
        <xsl:value-of select="*:persName/*:forename" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="*:persName/*:name" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="createPath">
    <xsl:param name="pXMLID" />
    <xsl:attribute name="href">javascript://</xsl:attribute>
    <xsl:attribute name="onclick">
      <xsl:text>javascript:window.open('</xsl:text><xsl:value-of select="$xtfURL" />view?docId=<xsl:value-of select="$indexS.path" />index.xml&#038;doc.view=popup&#038;chunk.id=<xsl:value-of select="$pXMLID" /><xsl:text>','popup','width=600, height=600, resizable=yes,scrollbars=yes').focus();</xsl:text>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="createExternalPath">
    <xsl:param name="pXMLID" />
    <xsl:attribute name="href">javascript://</xsl:attribute>
    <xsl:attribute name="onclick">
      <xsl:text>javascript:window.open('</xsl:text>
      <xsl:value-of select="$pXMLID" />
      <xsl:text>','popup','width=600, height=600, resizable=yes,scrollbars=yes').focus();</xsl:text>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="rowForOccurrence">
    <xsl:param name="pXMLID" />
    <tr>
      <td />
      <td>
        <!-- back to main doc -->
        <xsl:for-each select="$root">
          <!-- create links to occurrence -->
          <xsl:for-each select="key('index', $pXMLID)">
            <xsl:call-template name="createLinkToOccurrence" />
          </xsl:for-each>
        </xsl:for-each>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="createLinkToOccurrence">
    <xsl:if test="not(@subtype = '#editor')">
      <xsl:variable name="refchunk">
        <xsl:choose>
          <xsl:when test="ancestor::*:div4">
            <xsl:value-of select="ancestor::*:div4/@xml:id" />
          </xsl:when>
          <xsl:when test="ancestor::*:div3">
            <xsl:value-of select="ancestor::*:div3/@xml:id" />
          </xsl:when>
          <xsl:when test="ancestor::*:div2">
            <xsl:value-of select="ancestor::*:div2/@xml:id" />
          </xsl:when>
          <xsl:when test="ancestor::*:div1">
            <xsl:value-of select="ancestor::*:div1/@xml:id" />
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="target" select="@target" />
      <!--  <xsl:variable name="anchor"
                      select=" concat(@target,count(preceding:: *:ref[@target = $target])+1)"/>-->
      <!-- l'ancre n'est pas sur la page chargée -->
      <xsl:variable name="anchor" select="preceding::*:pb[1]/@xml:id" />
      <a target="content">
        <xsl:attribute name="href">
          <xsl:value-of select="$doc.path" />&#038;doc.view=content&#038;chunk.id=<xsl:value-of select="$refchunk" />&#038;toc.depth=<xsl:value-of select="$toc.depth" />&#038;brand=<xsl:value-of select="$brand" />&amp;#<xsl:value-of select="$anchor" /></xsl:attribute>
        <img alt="arrow" border="0" height="10" src="{$icon.path}arrow.gif" width="14" />
      </a>
      <xsl:choose>
        <xsl:when test="preceding::*:pb[position() = 1]/@n">
          <xsl:value-of select="preceding::*:pb[position() = 1]/@n" />
        </xsl:when>
        <xsl:otherwise>[i]</xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template name="createBiblioReference">
    <xsl:variable name="link" select="*:link/@facs" />
    <xsl:choose>
      <xsl:when test="$link">
        <a href="{$link}" style="color:brown; text-decoration: none" target="_blank">
          <i>
            <xsl:choose>
              <xsl:when test="*:title[@type = 'main']">
                <xsl:if test="@type = 'Oarticle'">
                  <xsl:value-of select="*:title[@type = 'sub']" />
                </xsl:if>
                <xsl:if test="not(@type = 'Oarticle')">
                  <xsl:value-of select="*:title[@type = 'main']" />
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="*:title" />
              </xsl:otherwise>
            </xsl:choose>
          </i>
          <xsl:choose>
            <xsl:when test="*:pubPlace">
              <xsl:value-of>, </xsl:value-of>
              <xsl:value-of select="concat(*:pubPlace, ': ', *:publisher, ', ', *:date, '.')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of>.</xsl:value-of>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <i>
          <xsl:value-of select="*:title" />
        </i>
        <xsl:choose>
          <xsl:when test="*:pubPlace">
            <xsl:value-of>, </xsl:value-of>
            <xsl:value-of select="concat(*:pubPlace, ': ', *:publisher, ', ', *:date, '.')" />
          </xsl:when>
          <xsl:otherwise>.</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="biblType">
    <xsl:if test="@type = 'pp'">P. </xsl:if>
    <xsl:if test="@type = 'll'">L. </xsl:if>
    <xsl:if test="@type = 'lib'">Lib. </xsl:if>
    <xsl:if test="@type = 'fol'">Fol. </xsl:if>
    <xsl:if test="@type = 'cap'">Cap. </xsl:if>
    <xsl:if test="@type = 'num'">Num. </xsl:if>
  </xsl:template>
  <xsl:template name="biblLink">
    <xsl:choose>
      <xsl:when test="*:link/@facs">
        <xsl:value-of select="*:link/@facs" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'X'" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="data">
    <hr />
    <h2>XML-Data</h2>
    <table>
      <tr>
        <td>
          <b>Source:</b>
        </td>
        <td>
          <a href="{$doc.adress}" style="color:brown; text-decoration: none" target="_blanc">
            <xsl:copy-of select="$doc.adress" />
          </a>
        </td>
      </tr>
      <tr>
        <td>
          <b>Index:</b>
        </td>
        <td>
          <a href="{concat ($index.path,'index.xml')}" style="color:brown; text-decoration: none" target="_blanc">
            <xsl:copy-of select="concat($index.path, 'index.xml')" />
          </a>
        </td>
      </tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
