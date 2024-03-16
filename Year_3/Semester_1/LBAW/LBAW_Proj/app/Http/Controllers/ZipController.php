<?php
   
namespace App\Http\Controllers;
   
use Illuminate\Http\Request;
use File;
use ZipArchive;
  
class ZipController extends Controller
{
    public function downloadZip(Request $request, $poll_id)
    {
        $zip = new ZipArchive;
   
        $fileName = 'poll_' . $poll_id . '_files.zip';

        if (!file_exists(public_path('storage/poll_files/' . $poll_id))) {
            mkdir(public_path('storage/poll_files/' . $poll_id), 0777, true);
            $file = fopen(public_path('storage/poll_files/' . $poll_id . '/NOTHING.txt'), 'w');
            fwrite($file, 'This poll has no files uploaded!');
            fclose($file);
        }
   
        if ($zip->open(public_path($fileName), ZipArchive::CREATE) === TRUE)
        {
            $filess = File::files(public_path('storage/poll_files/' . $poll_id));

            if (count($filess) > 1) {
                if (file_exists(public_path('storage/poll_files/' . $poll_id . '/NOTHING.txt'))) {
                    unlink(public_path('storage/poll_files/' . $poll_id . '/NOTHING.txt'));
                }
            }

            $files = File::files(public_path('storage/poll_files/' . $poll_id));

            foreach ($files as $key => $value) {
                $relativeNameInZipFile = basename($value);
                $zip->addFile($value, $relativeNameInZipFile);
            }
             
            $zip->close();
        }
    
        return response()->download(public_path($fileName));
    }
}