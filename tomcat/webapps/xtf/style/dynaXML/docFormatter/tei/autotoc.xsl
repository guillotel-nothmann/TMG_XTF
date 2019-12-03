<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xtf="http://cdlib.org/xtf" xmlns="http://www.w3.org/1999/xhtml"
   exclude-result-prefixes="#all">

   <!--
      Copyright (c) 2008, Regents of the University of California
      All rights reserved.
      
      Redistribution and use in source and binary forms, with or without 
      modification, are permitted provided that the following conditions are 
      met:
      
      - Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
      - Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.
      - Neither the name of the University of California nor the names of its
      contributors may be used to endorse or promote products derived from 
      this software without specific prior written permission.
      
      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
      AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
      ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
      LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
      CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
      SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
      INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
      CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
      ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
      POSSIBILITY OF SUCH DAMAGE.
   -->
   
   
   

   <xsl:import href="../common/docFormatterCommon.xsl"/>
   <xsl:import href="parameter.xsl"/>

   <xsl:template name="book.autotoc" exclude-result-prefixes="#all">
      <!-- book title -->
      <table cellpadding="0" cellspacing="0" class="title">


         <tr>
            <td>
               <a style="color:brown; text-decoration:none">
                  <xsl:attribute name="href">
                     <xsl:value-of select="$doc.path"/>;brand=<xsl:value-of select="$brand"
                        />;<xsl:value-of select="$search"/>
                  </xsl:attribute>
                  <xsl:attribute name="target">_top</xsl:attribute>

                  <xsl:choose>
                     <xsl:when test="/*/*:text/*:front/*:titlePage/*:titlePart[@type='main']">
                        <xsl:apply-templates
                           select="/*/*:text/*:front/*:titlePage/*:titlePart[@type='main']"
                           mode="text-only"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates select="/*/*:text/*:front/*:titlePage/*:titlePart"
                           mode="text-only"/>
                     </xsl:otherwise>
                  </xsl:choose>




               </a>
            </td>
         </tr>

      </table>



      <!-- hit summary -->
      <xsl:if test="($query != '0') and ($query != '')">
         <hr/>
         <xsl:call-template name="hitSummary"/>
      </xsl:if>
      <hr/>
      <!-- front -->
      <xsl:apply-templates select="/*/*:text/*:front/*[matches(name(),'^div')]" mode="toc"/>
      <br/>
      <!-- body -->
      <xsl:apply-templates select="/*/*:text/*:body/*[matches(name(),'^div')]" mode="toc"/>

      <!-- <br/>
      
      <table cellpadding="0" cellspacing="0" class="toc-line" border="0"><hr/>
         <tr>
            <td>
               <xsl:choose>
                  <xsl:when test="$toc.id='criticalApp'">
                     <a name="X"/>
                      <span class="toc-hi">Generate critical apparatus</span>
                  </xsl:when>
                  <xsl:otherwise>
                     <a style="color:brown; text-decoration:none" target="criticalApp.xsl">
                        <xsl:attribute name="href"
                           >http://localhost:8080/xtf/view?docId=tei/DC_100-319/DC_100-319.xml;chunk.id=criticalApp;toc.depth=1;toc.id=criticalApp;brand=default#X</xsl:attribute>
                        <xsl:attribute name="target">_top</xsl:attribute>Generate critical apparatus</a>
                     
                  </xsl:otherwise>
               </xsl:choose>
               
              
              
            </td>
         </tr>
      </table>-->


      <br/>
      <!-- back -->
      <xsl:apply-templates select="/*/*:text/*:back/*[matches(name(),'^div')]" mode="toc"/>
      <!-- hit summary -->
      <xsl:if test="($query != '0') and ($query != '')">
         <hr/>
         <xsl:call-template name="hitSummary"/>
      </xsl:if>
      <!-- expand/collapse all -->
      <xsl:call-template name="expandAll"/>
   </xsl:template>





   <!-- div processing template -->
   <xsl:template match="*[matches(name(),'^div')]" mode="toc" exclude-result-prefixes="#all">

      <xsl:if
         test="not(//*:interpretation//*:item[@n='parallelEdition'] and self::*:div1/@type='translation')">



         <!-- head element -->
         <xsl:variable name="head" select="*:head"/>
         <!-- hit count for this node -->
         <xsl:variable name="hit.count">
            <xsl:choose>
               <xsl:when test="($query != '0') and ($query != '') and (@xtf:hitCount)">
                  <xsl:value-of select="@xtf:hitCount"/>
               </xsl:when>
               <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <!-- hierarchical level -->
         
         
         <xsl:variable name="level" >
            <xsl:choose>
               <xsl:when test="//*:interpretation//*:item[@n='parallelEdition']">
                  <xsl:value-of select="count(ancestor::*[matches(name(),'^div')])"/>
               </xsl:when>
               <xsl:otherwise><xsl:value-of select="count(ancestor::*[matches(name(),'^div')]) + 1"/></xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <!-- number of pixels per hierarchical level -->
         <xsl:variable name="factor" select="25"/>

         <xsl:if test="$head">
            <table cellpadding="0" cellspacing="0" class="toc-line" border="0">
               <tr>
                  <!-- show node hits -->
                  <xsl:choose>
                     <xsl:when test="($query != '0') and ($query != '')">

                        <xsl:choose>
                           <xsl:when test="$hit.count != '0'">
                              <td width="{($level * $factor) + 10}" class="hits">
                                 <span class="hit-count">
                                    <xsl:value-of select="$hit.count"/>&#160; </span>
                              </td>
                           </xsl:when>
                           <xsl:otherwise>
                              <td width="{($level * $factor) + 10}" class="hits">&#160;</td>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:when>
                     <xsl:otherwise>
                        <td class="hits">
                           <xsl:attribute name="width">
                              <xsl:choose>
                                 <xsl:when test="$level=1">
                                    <xsl:value-of select="1"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="($level * $factor) - $factor"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute> &#160;</td>
                     </xsl:otherwise>
                  </xsl:choose>
                  <!-- create expand/collapse buttons -->
                  <xsl:choose>
                     <xsl:when
                        test="(number($toc.depth) &lt; ($level + 1) and *[matches(name(),'^div')]/*:head) and (not(@*:id = key('div-id', $toc.id)/ancestor-or-self::*/@*:id))">
                        <td class="expand">
                           <xsl:call-template name="expand"/>

                        </td>
                     </xsl:when>
                     <xsl:when
                        test="(number($toc.depth) > $level and *[matches(name(),'^div')]/*:head) or (@*:id = key('div-id', $toc.id)/ancestor-or-self::*/@*:id)">
                        <td class="expand">
                           <xsl:call-template name="collapse"/>
                        </td>
                     </xsl:when>
                     <xsl:otherwise>
                        <td class="expand">&#160;</td>
                     </xsl:otherwise>
                  </xsl:choose>
                  <!-- div number, if present -->
                  <xsl:if
                     test="(@n) or (following-sibling::*[matches(name(),'^div')]/@n) or (preceding-sibling::*[matches(name(),'^div')]/@n)">
                     <td class="divnum">

                        <xsl:choose>
                           <xsl:when test="@n">
                              <xsl:value-of select="@n"/>
                              <xsl:text>.&#160;</xsl:text>
                           </xsl:when>
                           <xsl:otherwise>&#160;</xsl:otherwise>
                        </xsl:choose>
                     </td>
                  </xsl:if>
                  <!-- actual title -->


                  <xsl:if test="not(self::*:div1/@type='source')">
                     <td class="head">
                        <xsl:apply-templates select="*:head[1]" mode="toc"/>
                     </td>
                  </xsl:if>
               </tr>
            </table>
            <!-- process node children if required -->
            <xsl:choose>
               <xsl:when test="number($toc.depth) > $level and *[matches(name(),'^div')]/*:head">
                  <xsl:apply-templates select="*[matches(name(),'^div')]" mode="toc"/>
               </xsl:when>
               <xsl:when test="@*:id = key('div-id', $toc.id)/ancestor-or-self::*/@*:id">
                  <xsl:apply-templates select="*[matches(name(),'^div')]" mode="toc"/>
               </xsl:when>
            </xsl:choose>
         </xsl:if>
      </xsl:if>
   </xsl:template>



   <!-- processs head element for toc -->
   <xsl:template match="*:head" mode="toc" exclude-result-prefixes="#all">

      <!-- hierarchical level -->
      <xsl:variable name="level" select="count(ancestor::*[matches(name(),'^div')])"/>

      <!-- mechanism by which the proper toc branch is expanded -->
      <xsl:variable name="local.toc.id">
         <xsl:choose>
            <!-- if this node is not terminal, expand this node -->
            <xsl:when test="parent::*[matches(name(),'^div')]/*[matches(name(),'^div')]">
               <xsl:value-of select="parent::*[matches(name(),'^div')]/@*:id"/>
            </xsl:when>
            <!-- if this node is terminal, expand the parent node -->
            <xsl:otherwise>
               <xsl:value-of
                  select="parent::*[matches(name(),'^div')]/parent::*[matches(name(),'^div')]/@*:id"
               />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="$chunk.id=ancestor::*[1]/@*:id">
            <a name="X"/>
            <div class="l{$level}">
               <span class="toc-hi">
                  <xsl:choose>
                     <xsl:when test="*:title/@type='main'">
                        <xsl:call-template name="substring">
                           <xsl:with-param name="titleParam">
                              <xsl:apply-templates select="*:title[@type='main']" mode="text-only"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:call-template name="substring">
                           <xsl:with-param name="titleParam">
                              <xsl:apply-templates select="*:title" mode="text-only"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:otherwise>
                  </xsl:choose>

               </span>
            </div>
         </xsl:when>
         <xsl:otherwise>
            <div class="l{$level}">
               <a style="color:brown; text-decoration:none">
                  <xsl:attribute name="href">
                     <xsl:value-of select="$doc.path"/>;chunk.id=<xsl:value-of
                        select="ancestor::*[1]/@*:id"/>;toc.depth=<xsl:value-of select="$toc.depth"
                        />;toc.id=<xsl:value-of select="$local.toc.id"/>;brand=<xsl:value-of
                        select="$brand"/><xsl:value-of select="$search"/><xsl:call-template
                        name="create.anchor"/>
                  </xsl:attribute>
                  <xsl:attribute name="target">_top</xsl:attribute>
                  <xsl:choose>
                     <xsl:when test="*:title/@type='main'">
                        <xsl:call-template name="substring">
                           <xsl:with-param name="titleParam">
                              <xsl:apply-templates select="*:title[@type='main']" mode="text-only"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:call-template name="substring">
                           <xsl:with-param name="titleParam">
                              <xsl:apply-templates select="*:title" mode="text-only"/>
                           </xsl:with-param>
                        </xsl:call-template>

                     </xsl:otherwise>
                  </xsl:choose>


               </a>
            </div>
         </xsl:otherwise>
      </xsl:choose>

   </xsl:template>

   <xsl:template name="substring">
      <xsl:param name="titleParam"/>

      <xsl:choose>
         <xsl:when test="string-length($titleParam)>60">
            <xsl:value-of
               select="substring($titleParam, 1, 60 + string-length(substring-before(substring($titleParam, 60),' ')))"
            />[...] </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$titleParam"/>
         </xsl:otherwise>
      </xsl:choose>



   </xsl:template>

   <xsl:template name="hitSummary" exclude-result-prefixes="#all">

      <xsl:variable name="sum">
         <xsl:choose>
            <xsl:when test="($query != '0') and ($query != '')">
               <xsl:value-of select="number(/*/@xtf:hitCount)"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="occur">
         <xsl:choose>
            <xsl:when test="$sum != 1">occurrences</xsl:when>
            <xsl:otherwise>occurrence</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <div class="hitSummary">
         <span class="hit-count">
            <xsl:value-of select="$sum"/>
         </span>
         <xsl:text>&#160;</xsl:text>
         <xsl:value-of select="$occur"/>
         <xsl:text> of </xsl:text>
         <span class="hit-count">
            <xsl:value-of select="$query"/>
         </span>
         <br/> [<a
            href="{$doc.path};chunk.id={$chunk.id};toc.depth={$toc.depth};toc.id={$toc.id};brand={$brand}"
            style="color:brown; text-decoration:none" target="_top">Clear Hits</a>] </div>

   </xsl:template>

   <!-- templates for expanding and collapsing single nodes -->
   <xsl:template name="expand" exclude-result-prefixes="#all">
      <xsl:variable name="local.toc.id" select="@*:id"/>
      <a>
         <xsl:attribute name="href">
            <xsl:value-of select="$doc.path"/>;chunk.id=<xsl:value-of select="$chunk.id"
               />;toc.id=<xsl:value-of select="$local.toc.id"/>;brand=<xsl:value-of select="$brand"
            />
         </xsl:attribute>
         <xsl:attribute name="target">_top</xsl:attribute>
         <img src="{$icon.path}i_expand.gif" border="0" alt="expand section"/>
      </a>
   </xsl:template>

   <xsl:template name="collapse" exclude-result-prefixes="#all">
      <xsl:variable name="local.toc.id">
         <!-- HERE -->
         <xsl:choose>
            <xsl:when test="*:head and @*:id">
               <xsl:value-of select="parent::*[*:head and @*:id]/@*:id"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="0"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <a>
         <xsl:attribute name="href">
            <xsl:value-of select="$doc.path"/>;chunk.id=<xsl:value-of select="$chunk.id"
               />;toc.id=<xsl:value-of select="$local.toc.id"/>;brand=<xsl:value-of select="$brand"
               /><xsl:value-of select="$search"/>
         </xsl:attribute>
         <xsl:attribute name="target">_top</xsl:attribute>
         <img src="{$icon.path}i_colpse.gif" border="0" alt="collapse section"/>
      </a>
   </xsl:template>

   <!-- expand or collapse entire hierarchy -->
   <xsl:template name="expandAll" exclude-result-prefixes="#all">
      <hr/>
      <div class="expandAll">
         <img src="{$icon.path}i_colpse.gif" border="0" alt="collapse section"/>
         <xsl:text>&#160;</xsl:text>
         <a style="color:brown; text-decoration:none">
            <xsl:attribute name="href">
               <xsl:value-of select="$doc.path"/>;chunk.id=<xsl:value-of select="$chunk.id"
                  />;toc.depth=<xsl:value-of select="1"/>;brand=<xsl:value-of select="$brand"
                  /><xsl:value-of select="$search"/>
            </xsl:attribute>
            <xsl:attribute name="target">_top</xsl:attribute>
            <xsl:text>Collapse All</xsl:text>
         </a>
         <xsl:text> | </xsl:text>
         <a style="color:brown; text-decoration:none">
            <xsl:attribute name="href">
               <xsl:value-of select="$doc.path"/>;chunk.id=<xsl:value-of select="$chunk.id"
                  />;toc.depth=<xsl:value-of select="100"/>;brand=<xsl:value-of select="$brand"
                  /><xsl:value-of select="$search"/>
            </xsl:attribute>
            <xsl:attribute name="target">_top</xsl:attribute>
            <xsl:text>Expand All</xsl:text>
         </a>
         <xsl:text>&#160;</xsl:text>
         <img src="{$icon.path}i_expand.gif" border="0" alt="expand section"/>
      </div>
   </xsl:template>

   <!-- used to extract the text of titles without <lb/>'s and other formatting -->
   <xsl:template match="text()" mode="text-only"> 
     
      <xsl:choose>
         <xsl:when test=" not((contains($pc, 'true'))) and  following::*[1]/@type = 't2'">
            <xsl:value-of select="replace(., '\s+$', '', 'm')"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="self::text()"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>




   <xsl:template match="*:choice" mode="text-only">
      <xsl:choose>
         <!-- une alternative "choice" correspond à un hit  -->
         <xsl:when test="ancestor::*:choice[@xtf:hitCount] and not(descendant::xtf:term)">
            <span class="hit">
               <xsl:if test="@n='1' or @n='4'">
                  <xsl:call-template name="choice_1"/>
               </xsl:if>
               <xsl:if test="@n='2'">
                  <xsl:call-template name="choice_2"/>
               </xsl:if>
               <xsl:if test="@n='3'">
                  <xsl:apply-templates/>
               </xsl:if>
               <xsl:if test="@n='4'">
                  <xsl:call-template name="choice_4"/>
               </xsl:if>
            </span>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="@n='1'">
               <xsl:call-template name="choice_1"/>
            </xsl:if>
            <xsl:if test="@n='2'">
               <xsl:call-template name="choice_2"/>
            </xsl:if>
            <xsl:if test="@n='3'">
               <!-- majuscules après incise majeure? -->
               <xsl:call-template name="choice_1"/>
            </xsl:if>
            <xsl:if test="@n='4'">
               <xsl:call-template name="choice_4"/>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*:add" mode="text-only">
      
      <xsl:choose>
         <xsl:when test="$add='true'">
            <xsl:choose>
               <xsl:when test="@resp='author'">
                  <span class="int_author">
                     <xsl:apply-templates mode="text-only"/>
                  </span>
               </xsl:when>
               <xsl:when test="@resp='editor'">
                  <span class="int_editor">
                     <xsl:apply-templates mode="text-only"/>
                  </span>
               </xsl:when>
               <xsl:otherwise>
                  <span class="int_other">
                     <xsl:apply-templates mode="text-only"/>
                  </span>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates mode="text-only"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*:quote" mode="toc">
      <xsl:apply-templates mode="text-only" select="."/>
   </xsl:template>

   <xsl:template match="*:del" mode="text-only">
      <xsl:choose>
         <xsl:when test="$del='true'">
            <xsl:choose>
               <xsl:when test="@resp='author'">
                  <span class="int_author"> [<xsl:apply-templates mode="text-only"/>] </span>
               </xsl:when>
               <xsl:when test="@resp='editor'">
                  <span class="int_editor">[<xsl:apply-templates mode="text-only"/>]</span>
               </xsl:when>
               <xsl:otherwise>
                  <span class="int_other">[<xsl:apply-templates mode="text-only"/>]</span>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise/>
      </xsl:choose>
   </xsl:template>
   
 


   <!-- ponctuation-->
   <xsl:template match="*:pc" mode="text-only">
      <xsl:if test="not (contains($pc, 'true'))">
         <xsl:if test="@type='t0'">
            <xsl:value-of/>
         </xsl:if>
         <xsl:if test="@type='t1'">
            <xsl:value-of>. </xsl:value-of>
         </xsl:if>
         <xsl:if test="@type='t2'">
            <xsl:value-of>, </xsl:value-of>
         </xsl:if>
         <xsl:if test="@type='t3'">
            <xsl:value-of>? </xsl:value-of>
         </xsl:if>
         <xsl:if test="@type='t4'">
            <xsl:value-of>! </xsl:value-of>
         </xsl:if>
         <xsl:if test="@type='t5'">
            <xsl:value-of>; </xsl:value-of>
         </xsl:if>
         <xsl:if test="@type='t6'">
            <xsl:value-of>: </xsl:value-of>
         </xsl:if>
         <xsl:if test="@type='t7'">
            <xsl:value-of>–</xsl:value-of>
            <!-- demi cadratin -->
         </xsl:if>
         <xsl:if test="@type='t8'">
            <xsl:value-of>(</xsl:value-of>
         </xsl:if>
         <xsl:if test="@type='t9'">
            <xsl:value-of>)</xsl:value-of>
         </xsl:if>
         <xsl:if test="@type='t10'">
            <xsl:value-of>-</xsl:value-of>
         </xsl:if>
         <xsl:if test="@type='t11'">
            <xsl:value-of>|</xsl:value-of>
         </xsl:if>
         <xsl:if test="@type='t12'">
            <xsl:choose>
               <xsl:when test="$lb='true'">
                  <xsl:value-of>-</xsl:value-of>
               </xsl:when>
               <xsl:when test="name(following::*[2])='pb'">
                  <xsl:value-of>-</xsl:value-of>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:if>
         <!-- hyphen -->
      </xsl:if>
      <xsl:if test="  (contains($pc, 'true'))">
         <xsl:choose>
            <xsl:when test="@type='t12' and $lb='false'"> </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="node()"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>

      <xsl:if test="@type='t13'">
         <xsl:value-of>/</xsl:value-of>
      </xsl:if>
   </xsl:template>







</xsl:stylesheet>
