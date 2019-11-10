scan_folder = '~/Library/Mobile Documents/iCloud~com~readdle~Scanner~PDF/Documents'
icloud_folder = '~/Library/Mobile Documents/com~apple~CloudDocs'
paperwork_folder = File.join(icloud_folder,'/Paperwork')
inbox_folder = File.join(paperwork_folder,"/inbox")


def move_file(file, destination)
  FileUtils.mkdir_p(File.expand_path(destination))
  move(file, destination)
end

Maid.rules do

  rule 'Documents' do
    dir_safe(File.join(scan_folder, '/*{Scan,Privat,Arbeit}*.pdf')).each { |path|

      file_name = path
      file_name_wo_ext = File.basename(path,File.extname(path))

      unless file_name_wo_ext.to_s.strip.empty?
        filename_parts = file_name_wo_ext.split(" ")
        if file_name_wo_ext.start_with?("Scan") then
          log("Unknown document type. Move to " + inbox_folder)
          move_file(file_name, inbox_folder)
        else
          document_type = filename_parts[0]
          target_type = filename_parts[1]
          year = Date.parse(filename_parts[2]).year

          destination = File.join(paperwork_folder, year.to_s, target_type, document_type)
          move_file(file_name, destination)
        end
      end
    }
  end
end