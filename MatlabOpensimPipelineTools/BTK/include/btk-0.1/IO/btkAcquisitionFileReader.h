/* 
 * The Biomechanical ToolKit
 * Copyright (c) 2009-2012, Arnaud Barré
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 *     * Redistributions of source code must retain the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials
 *       provided with the distribution.
 *     * Neither the name(s) of the copyright holders nor the names
 *       of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written
 *       permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef __btkAcquisitionFileReader_h
#define __btkAcquisitionFileReader_h

#include "btkException.h"
#include "btkProcessObject.h"
#include "btkAcquisition.h"
#include "btkAcquisitionFileIO.h"

namespace btk
{
  class AcquisitionFileReaderException : public Exception
  {
  public:
    explicit AcquisitionFileReaderException(const std::string& msg)
    : Exception(msg)
    {};
      
    virtual ~AcquisitionFileReaderException() throw() {};
  };
  
  class AcquisitionFileReader : public ProcessObject
  {
  public:
    typedef SharedPtr<AcquisitionFileReader> Pointer;
    typedef SharedPtr<const AcquisitionFileReader> ConstPointer;
    
    virtual ~AcquisitionFileReader() {};
    
    static Pointer New() {return Pointer(new AcquisitionFileReader());};
    
    Acquisition::Pointer GetOutput() {return this->GetOutput(0);};
   
    bool GetDisableFilenameExceptionState() const {return this->m_FilenameExtensionDisabled;};
    void SetDisableFilenameExceptionState(bool s) {this->m_FilenameExtensionDisabled = s;};
    const std::string& GetFilename() const {return this->m_Filename;};
    BTK_IO_EXPORT void SetFilename(const std::string& filename);
    AcquisitionFileIO::Pointer GetAcquisitionIO() {return this->m_AcquisitionIO;};
    AcquisitionFileIO::ConstPointer GetAcquisitionIO() const {return this->m_AcquisitionIO;};
    BTK_IO_EXPORT void SetAcquisitionIO(AcquisitionFileIO::Pointer io = AcquisitionFileIO::Pointer());
  
  protected:
    BTK_IO_EXPORT AcquisitionFileReader();
    
    Acquisition::Pointer GetOutput(int idx) {return static_pointer_cast<Acquisition>(this->GetNthOutput(idx));};
    BTK_IO_EXPORT virtual DataObject::Pointer MakeOutput(int idx);
    BTK_IO_EXPORT virtual void GenerateData();
    
    AcquisitionFileIO::Pointer m_AcquisitionIO;
    std::string m_Filename;
    
  private:
    AcquisitionFileReader(const AcquisitionFileReader& ); // Not implemented.
    AcquisitionFileReader& operator=(const AcquisitionFileReader& ); // Not implemented.

    bool m_FilenameExtensionDisabled;
  };
};

#endif // __btkAcquisitionFileReader_h
