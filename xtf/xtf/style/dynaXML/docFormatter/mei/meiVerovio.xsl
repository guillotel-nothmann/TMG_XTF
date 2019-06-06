<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:xtf="http://cdlib.org/xtf"
    xmlns:session="java:org.cdlib.xtf.xslt.Session" extension-element-prefixes="session"
    exclude-result-prefixes="#all">




    <!-- import -->
    <xsl:import href="../common/docFormatterCommon.xsl"/> 
     
     
     <!-- parameters -->
    <xsl:param name="http.referer"/>
    
    <!-- variables -->
 
    <xsl:variable name="musicSource" select="substring-after($http.referer, ';&#038;music.id=')"></xsl:variable>
 
 
    <!-- run through all nodes -->

    <xsl:strip-space elements="*"/>
    <xsl:template match="@*|node()" mode="meiTransform">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="meiTransform"/>
        </xsl:copy>
    </xsl:template>


    <!-- HEAD -->
    <!-- do not send the header -->
    <xsl:template match="*:meiHead" mode="meiTransform"/>


    <!-- MUSIC -->

    <xsl:template match="*:section" mode="meiTransform">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="meiTransform"/>
        </xsl:copy>
    </xsl:template>


    <!-- STRUCTURE -->
    <xsl:template match="@lines[parent::*:staffDef]" mode="meiTransform">
         <xsl:attribute name="lines">
            <xsl:value-of select="'5'"/>
         </xsl:attribute>
            
    </xsl:template>
    
    
    
    
    <xsl:template match="*:staff" mode="meiTransform">
        <xsl:choose>
            <xsl:when test="descendant::*:uneume and count(//*:staff)=1">
                <xsl:apply-templates select="node()" mode="meiTransform"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()" mode="meiTransform"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*:layer" mode="meiTransform">
        <xsl:choose>
            <xsl:when test="descendant::*:uneume and count(//*:staff)=1">
                <xsl:for-each-group select="node()"
                    group-ending-with="*:uneume[position() mod 10 = 0]">
                    <measure xmlns="http://www.music-encoding.org/ns/mei">
                        <staff n="1" xmlns="http://www.music-encoding.org/ns/mei">
                            <layer n="1" xmlns="http://www.music-encoding.org/ns/mei">
                                <xsl:apply-templates select="current-group()" mode="meiTransform"/>
                            </layer>
                        </staff>
                        <xsl:for-each select="current-group()[self::*:uneume]">
                            <xsl:call-template name="neum2Slur">
                                <xsl:with-param name="slurNode" select="."/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </measure>
                    <sb xmlns="http://www.music-encoding.org/ns/mei"/>
                </xsl:for-each-group>
                <!--<xsl:apply-templates select="node()" mode="meiTransform"/>-->
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()" mode="meiTransform"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*:measure" mode="meiTransform">
        <xsl:choose>
            <xsl:when test="*:supplied/*:barLine/@rend and $musicEmend='true'">
                <xsl:copy>
                    <xsl:attribute name="right" select="*:supplied/*:barLine/@rend"/>
                    <xsl:apply-templates select="node()" mode="meiTransform"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="node()|@*" mode="meiTransform"/>

                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- EVENTS -->

    <xsl:template match="*:clef" mode="meiTransform">
        <xsl:choose>
            <xsl:when test="@shape='F' and @line='2'">
                <xsl:copy>
                    <xsl:attribute name="shape">C</xsl:attribute>
                    <xsl:attribute name="line">4</xsl:attribute>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <!-- créer exceptions pour fa2 -->
    </xsl:template>

    <!-- NEUME NOTATION -->
    <xsl:template match="*:uneume" mode="meiTransform">
        <xsl:apply-templates select="child::*" mode="meiTransform"/>
    </xsl:template>

    <xsl:template match="*:note" mode="meiTransform">
        <xsl:copy>
            <xsl:if test="not(@dur)">
                <xsl:attribute name="dur">4</xsl:attribute>
            </xsl:if>
            <!-- neumes -->

            <xsl:apply-templates select="@*|node()" mode="meiTransform"/>
        </xsl:copy>
    </xsl:template>


    <!-- Bar Line -->
    <xsl:template match="*:barLine" mode="meiTransform">
        <xsl:choose>
            <xsl:when test="//*:staffDef/@lines=5">
                <xsl:copy-of select="self::*"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="*:slur" mode="meiTransform">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template name="neum2Slur">
        <xsl:param name="slurNode"/>
        <xsl:if test="count($slurNode//*:note)>1"/>
        <xsl:variable name="start" select="$slurNode/*:note[1]/@xml:id"/>
        <xsl:variable name="end" select="$slurNode/*:note[count($slurNode//*:note)]/@xml:id"/>
        <xsl:if test="$start!=$end">
            <slur xmlns="http://www.w3.org/1999/xhtml">
                <xsl:attribute name="startid">
                    <xsl:value-of select="$start"/>
                </xsl:attribute>
                <xsl:attribute name="endid">
                    <xsl:value-of select="$end"/>
                </xsl:attribute>
            </slur>
        </xsl:if>
    </xsl:template>


    <!-- CRITICAL APP -->
    <xsl:template match="*:app" mode="meiTransform">

        <xsl:choose>
            <xsl:when test="$musicOriginal='true'">
                <xsl:apply-templates select="*:rdg[@label='original']" mode="meiTransform"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*:rdg[@label='normalized']" mode="meiTransform"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="*:rdg[@source=$musicSource]" mode="meiTransform"/>
    </xsl:template>

    <xsl:template match="*:rdg" mode="meiTransform">
       <xsl:apply-templates mode="meiTransform" select="*"/>
    </xsl:template>


    <xsl:template match="*:choice" mode="meiTransform">
        <xsl:choose>
            <xsl:when test="$musicOriginal='true'">
                <xsl:apply-templates select="*:orig" mode="meiTransform"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*:reg" mode="meiTransform"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*:orig" mode="meiTransform">
        <xsl:if test="$musicOriginal='true'">
            <xsl:copy-of select="*"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:reg" mode="meiTransform">
        <xsl:if test="$musicOriginal='false'">
            <xsl:apply-templates select="*" mode="meiTransform"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:supplied" mode="meiTransform">
        <xsl:if test="$musicEmend='true'">
            <xsl:copy-of select="."/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
