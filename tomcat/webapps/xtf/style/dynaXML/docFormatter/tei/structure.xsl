<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all">

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

   <!-- Import sheets -->
   <xsl:import href="../common/docFormatterCommon.xsl"/>
   <xsl:import href="parallelEdition.xsl"/>


   <!-- templates -->

   <xsl:template match="*:TEI.2">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="*:teiHeader"/>

   <xsl:template match="*:text">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="*:front">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="*:body">

      <xsl:apply-templates/>

   </xsl:template>

   <xsl:template match="*:back">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="*:div1[@type='dedication']"/>

   <!-- all div elements -->
   <xsl:template match="*[matches(local-name(),'^div')]">
      <!-- Decorative break or ornament? -->
      <xsl:choose>
         <xsl:when test="@type='textbreak'">
            <xsl:choose>
               <xsl:when test="@rend='ornament'">
                  <div align="left">
                     <table border="0" width="40%">
                        <tr align="left">
                           <td>&#x2022;</td>
                           <td>&#x2022;</td>
                           <td>&#x2022;</td>
                        </tr>
                     </table>
                  </div>
               </xsl:when>
               <xsl:otherwise>
                  <table border="0" width="40%">
                     <tr>
                        <td>&#160;</td>
                        <td>&#160;</td>
                        <td>&#160;</td>
                     </tr>
                  </table>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="@rend='ornament'">
               <div align="left">
                  <table border="0" width="40%">
                     <tr align="left">
                        <td>&#x2022;</td>
                        <td>&#x2022;</td>
                        <td>&#x2022;</td>
                     </tr>
                  </table>
               </div>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
      <!-- process div -->

      <xsl:if test="child::*:head[not (preceding-sibling::*:pb)] and $chunk.id=@xml:id">

         <xsl:apply-templates select="preceding::*:pb[1]"/>
      </xsl:if>
      
      <xsl:choose>
         <xsl:when test="//*:interpretation//*:item[@n='parallelEdition']">
            <xsl:copy> 
               <xsl:apply-templates mode="parallelEdition"/> 
            </xsl:copy>
         </xsl:when>
         
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="descendant::*:del//*:note/@type='marginalia' and $del='true'">
                  <div class="marginalia">
                     <xsl:apply-templates/>
                  </div>
               </xsl:when>
               <xsl:when test="descendant::*:note[@type='marginalia' and not(ancestor::*:del)]"> 
                  <xsl:choose>
                     <xsl:when test="@xml:id=$chunk.id"> <!-- only highest unit in chunck gets div/class='marginalia' -->
                        <div class="marginalia"> 
                           <xsl:apply-templates/>
                        </div>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates/>
                     </xsl:otherwise>
                  </xsl:choose>
                  
               </xsl:when>
               <xsl:otherwise>
                  <xsl:apply-templates/>
               </xsl:otherwise>
            </xsl:choose>
            
         </xsl:otherwise>
      </xsl:choose>

      
   </xsl:template>
</xsl:stylesheet>
