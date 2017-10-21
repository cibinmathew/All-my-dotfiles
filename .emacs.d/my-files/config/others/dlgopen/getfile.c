/****************************************************************************
 * File name           :                                                    *
 * Author              : Binu Jose Philip                                   *
 * Modified By         :                                                    *
 * Last modified       : Time-stamp: "26-09-1998, 05:34 pm"                 *
 *                                                                          *
 ***************************************************************************/

#include <windows.h>
#include <commdlg.h>
#include <string.h>
#include <stdio.h>

#define BUF_SIZE        4096

void slashify ( char * string);

int main (int argc, char ** argv)
{
  
    OPENFILENAME openParams;

    char buf_buffer[BUF_SIZE * 4] = "*.*";
    char * buffer;
    char selected[BUF_SIZE] = "Life is a sad joke";
    char filters[BUF_SIZE] = "All files *.* ";
    FILE * file;
    int result;

    buffer = buf_buffer;
    filters[9] = filters[13] = 0;

    openParams.lStructSize = sizeof (OPENFILENAME); 
    openParams.hwndOwner = NULL;
    openParams.hInstance = 0;
    openParams.lpstrFilter = filters; 
    openParams.lpstrCustomFilter = NULL; 
    openParams.nMaxCustFilter = 0;
    openParams.nFilterIndex = 0; 
    openParams.lpstrFile = buffer;
    openParams.nMaxFile = BUF_SIZE * 4; 
    openParams.lpstrFileTitle = selected; 
    openParams.nMaxFileTitle = BUF_SIZE; 
    openParams.lpstrInitialDir = NULL; 
    openParams.lpstrTitle = NULL; 
    openParams.Flags = OFN_ALLOWMULTISELECT | OFN_NOCHANGEDIR | OFN_EXPLORER; 
    openParams.nFileOffset = 0; 
    openParams.nFileExtension = 0;  
    openParams.lpstrDefExt = NULL; 
    openParams.lCustData = 0; 
    openParams.lpfnHook = NULL; 
    openParams.lpTemplateName = NULL; 

    if (!GetOpenFileName (&openParams)) 
        exit (1);

    slashify ( buffer);

    while (*buffer != 0) {
        printf ( "%s\n", buffer);
        buffer = buffer + strlen ( buffer) + 1;
    }

    return 0;
}

void slashify ( char * string)
{
    if (string != NULL) 
        while (*string++) 
            if (*string == '\\')
                *string = '/';
}

