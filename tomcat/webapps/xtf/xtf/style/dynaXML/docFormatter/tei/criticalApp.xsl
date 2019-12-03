<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:xtf="http://cdlib.org/xtf"
    xmlns:session="java:org.cdlib.xtf.xslt.Session" extension-element-prefixes="session"
    exclude-result-prefixes="#all">




    <xsl:template name="criticalApp">


        <table border="1">
            <xsl:for-each select="//*">


                <xsl:choose> 
                    <xsl:when test="self::*:choice[@n='3']">
                        <tr>
                            <td> 
                                <xsl:value-of select="preceding::*:pb[1]/@n"/> 
                            </td>
                            <td>Orthography</td>
                            <td>
                                <xsl:apply-templates select="*:orig" mode="criticalApp"/>
                            </td>
                            <td>
                                <xsl:apply-templates select="*:reg" mode="criticalApp"/>
                            </td>
                        </tr>
                    </xsl:when>

                     <xsl:when test="self::*:add">
                         <tr>
                             <td>
                                 <xsl:value-of select="preceding::*:pb[1]/@n"></xsl:value-of>
                             </td>
                             <td>
                                 Addition
                             </td>
                             <td> 
                                 
                             </td>
                             <td>
                                 <xsl:variable name="context">
                                     <xsl:apply-templates select="preceding::node()[1]" mode="criticalApp"></xsl:apply-templates>
                                     <xsl:text> </xsl:text>
                                  
                                     <hi rend="ul"><xsl:apply-templates select="."></xsl:apply-templates></hi>
                                     <xsl:text> </xsl:text>
                               
                                     <xsl:apply-templates select="following::node()[1]" mode="criticalApp"></xsl:apply-templates>
                                 </xsl:variable>
                                 
                                 <xsl:apply-templates select="$context" mode="criticalApp"/>
                             </td>
                         </tr>
                     </xsl:when> 

                </xsl:choose>


            </xsl:for-each>
        </table>





    </xsl:template>


    <xsl:template match="*:choice[@n='1']" mode="criticalApp">
        <xsl:apply-templates select="*:reg" mode="criticalApp"/>

    </xsl:template>

    <xsl:template match="*:choice[@n='2']" mode="criticalApp">
        <xsl:apply-templates select="*:expan" mode="criticalApp"/>
    </xsl:template>
    
    <xsl:template match="*:hi [@rend='ul']" mode="criticalApp">
        <u><xsl:copy-of select="."></xsl:copy-of></u>
        
    </xsl:template>









</xsl:stylesheet>
