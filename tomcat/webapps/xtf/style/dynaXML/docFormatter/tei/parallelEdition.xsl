<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all">

    <!-- import -->
    <xsl:import href="../common/docFormatterCommon.xsl"/>

    <xsl:template match="@*|node()" mode="parallelEdition">
        <xsl:copy>
            <xsl:apply-templates select="." mode="parallelEdition"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="createDivision">
        <xsl:param name="TD1"/>
        <xsl:param name="TD2"/>
        <xsl:param name="style"/>

        <xsl:choose>
            <xsl:when test="$style='pNormal'">
                <tr>
                    <td width="47%" valign="top">
                        <p class="normal"
                            style="text-align:justify; line-height:1.4em; font-size: 1.15em">
                            <xsl:apply-templates select="$TD1"/>
                        </p>
                    </td>
                    <td width="6%"/>
                    <td width="47%" valign="top">
                        <p class="normal"
                            style="text-align:justify; line-height:1.4em; font-size: 1.15em">
                            <xsl:apply-templates select="$TD2"/>
                        </p>
                    </td>
                </tr>

            </xsl:when>

            <xsl:when test="$style='pNoIndent'">
                <tr>
                    <td width="47%" valign="top">
                        <p class="noindent"
                            style="text-align:justify; line-height:1.4em; font-size: 1.15em">
                            <xsl:apply-templates select="$TD1"/>
                        </p>
                    </td>
                    <td width="6%"/>
                    <td width="47%" valign="top">
                        <p class="noindent"
                            style="text-align:justify; line-height:1.4em; font-size: 1.15em">
                            <xsl:apply-templates select="$TD2"/>
                        </p>
                    </td>
                </tr>

            </xsl:when>
            <xsl:otherwise>
                <tr>
                    <td width="47%" valign="top">
                        <xsl:apply-templates select="$TD1"/>
                    </td>
                    <td width="6%"/>
                    <td width="47%" valign="top">
                        <xsl:apply-templates select="$TD2"/>
                    </td>
                </tr>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="footnoteParallelEdition">
        <xsl:variable name="mainCorresp"
            select=" substring(//*[@xml:id=$chunk.id]/@corresp,2)"/>

        <tr>
            <td width="47%" valign="top">
                <xsl:for-each
                    select="key('div-id', $chunk.id)//*:note[@type='footnote'][ancestor::*/@xml:id=$chunk.id]">
                    <div class="footnotes"> 
                        <xsl:element name="a">
                            <xsl:attribute name="name">
                                <xsl:text>fn_main</xsl:text>
                                <xsl:number level="any" format="a"
                                    count="*:note[@type='footnote'][ancestor::*/@xml:id=$chunk.id]"
                                />
                            </xsl:attribute>
                            <a style="text-decoration: none">
                                <xsl:attribute name="href">
                                    <xsl:text>#fna_main</xsl:text>
                                    <xsl:number level="any" format="a"
                                        count="*:note[@type='footnote'][ancestor::*/@xml:id=$chunk.id]"
                                    />
                                </xsl:attribute>
                                <span style="font-size:0.6em;vertical-align:super;color:brown;">
                                    <xsl:number level="any" format="a"
                                        count="*:note[@type='footnote'][ancestor::*/@xml:id=$chunk.id]"/>
                                    <xsl:text> </xsl:text>
                                </span>
                            </a>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </div>
                </xsl:for-each>
            </td>
            <td width="6%"/>
            <td width="47%" valign="top">
                
                <xsl:for-each
                    select="key('div-id', $mainCorresp)//*:note[@type='footnote'][ancestor::*/@xml:id=$mainCorresp]">
                    <div class="footnotes">
                         
                        <xsl:element name="a">
                            <xsl:attribute name="name">
                                <xsl:text>fn_sec</xsl:text>
                                <xsl:number level="any"  
                                    count="*:note[@type='footnote'][ancestor::*/@xml:id=$mainCorresp]"
                                />
                            </xsl:attribute>
                            <a style="text-decoration: none">
                                <xsl:attribute name="href">
                                    <xsl:text>#fna_sec</xsl:text>
                                    <xsl:number level="any"  
                                        count="*:note[@type='footnote'][ancestor::*/@xml:id=$mainCorresp]"
                                    />
                                </xsl:attribute>
                                <span style="font-size:0.6em;vertical-align:super;color:brown;">
                                    <xsl:number level="any"  
                                        count="*:note[@type='footnote'][ancestor::*/@xml:id=$mainCorresp]"/>
                                    <xsl:text> </xsl:text>
                                </span>
                            </a>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </div>
                </xsl:for-each>
            </td>
        </tr>

    </xsl:template>



    <xsl:template match="*" mode="parallelEdition">
        <xsl:apply-templates mode="parallelEdition"/>
    </xsl:template>

    <xsl:template match="*:head[ parent::*[matches(local-name(),'^div')]]" mode="parallelEdition">
        <xsl:variable name="xmlID">
            <xsl:value-of select="parent::*[matches(local-name(),'^div')]/@corresp"/>
        </xsl:variable>
        <xsl:call-template name="createDivision">
            <xsl:with-param name="TD1" select="."/>
            <xsl:with-param name="TD2" select="//*:head[parent::*/@xml:id=substring($xmlID,2)][1]"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*:l" mode="parallelEdition">
        <xsl:variable name="xmlID">
            <xsl:value-of select="ancestor::*[matches(local-name(),'^div')][1]/@corresp"/>
        </xsl:variable>
        <xsl:variable name="position" select="count(preceding-sibling::*:l)+1"/>

        <xsl:call-template name="createDivision">
            <xsl:with-param name="TD1" select="."/>
            <xsl:with-param name="TD2"
                select="//*:l[$position][ancestor::*/@xml:id=substring($xmlID,2)]"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*:lg" mode="parallelEdition">
        <xsl:apply-templates mode="parallelEdition"/>
    </xsl:template>

    <xsl:template match="*:p" mode="parallelEdition">
        <xsl:choose>
            <xsl:when test=" child::*:pb">
                <xsl:variable name="xmlID">
                    <xsl:value-of select="ancestor::*[matches(local-name(),'^div')][1]/@corresp"/>
                </xsl:variable>
                <xsl:variable name="position" select="count(preceding-sibling::*:p)+1"/>




                <xsl:for-each-group select="node()" group-starting-with="*:pb">
                    <xsl:if test="current-group()[self::*:pb]">
                        <xsl:apply-templates select="current-group()[self::*:pb]"
                            mode="parallelEdition"/>
                    </xsl:if>

                    <xsl:choose>
                        <xsl:when test="position()=1">
                            <xsl:call-template name="createDivision">
                                <xsl:with-param name="TD1"
                                    select="current-group()[not (self::*:pb)]"/>
                                <xsl:with-param name="TD2"
                                    select="//*:p[$position][ancestor::*/@xml:id=substring($xmlID,2)]/child::node()[not(preceding-sibling::*:pb) and not(self::*:pb)]"/>
                                <xsl:with-param name="style">pNormal</xsl:with-param>
                            </xsl:call-template>

                        </xsl:when>

                        <xsl:when test="position()=2">
                            <xsl:call-template name="createDivision">
                                <xsl:with-param name="TD1"
                                    select="current-group()[not (self::*:pb)]"/>
                                <xsl:with-param name="TD2"
                                    select="//*:p[$position][ancestor::*/@xml:id=substring($xmlID,2)]/child::node()[not(following-sibling::*:pb) and not(self::*:pb)]"/>
                                <xsl:with-param name="style">pNoIndent</xsl:with-param>
                            </xsl:call-template>

                        </xsl:when>

                        <xsl:otherwise>


                            <xsl:call-template name="createDivision">
                                <xsl:with-param name="TD1"
                                    select="current-group()[not (self::*:pb)]"/>
                                <xsl:with-param name="TD2" select="current-group()"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>



            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="xmlID">
                    <xsl:value-of select="ancestor::*[matches(local-name(),'^div')][1]/@corresp"/>
                </xsl:variable>
                <xsl:variable name="position" select="count(preceding-sibling::*:p)+1"/>

                <xsl:call-template name="createDivision">
                    <xsl:with-param name="TD1" select="."/>
                    <xsl:with-param name="TD2"
                        select="//*:p[$position][ancestor::*/@xml:id=substring($xmlID,2)]"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*:pb" mode="parallelEdition">
        <tr>
            <td colspan="3">
                <xsl:apply-templates select="."/>
            </td>
        </tr>
    </xsl:template> 
</xsl:stylesheet>
