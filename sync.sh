#! /bin/bash

PHOTO_EXTENSIONS=${PHOTO_EXTENSIONS:-"jpg gif png"}
VIDEO_EXTENSIONS=${VIDEO_EXTENSIONS:-"mov mp4 mpeg"}

while getopts "s:h:t:e:p:p:v:V:" opt; do
  case ${opt} in
    s) sourceDir=$OPTARG ;;
    p) photoDestDir=$OPTARG ;;
    P) PHOTO_EXTENSIONS=$OPTARG ;;
    v) videoDestDir=$OPTARG ;;
    V) VIDEO_EXTENSIONS= $OPTARG ;;
    h) PP_HOST=$OPTARG ;;
    t) PP_API_KEY=$OPTARG ;;
    e) SORT_PHOTOS_PATH=$OPTARG ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;; # Invalid option
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;; # Missing argument
  esac
done

# Shift off the processed options
shift $((OPTIND -1))



startCount=$(find ${sourceDir} -maxdepth 1 -type f -not -path '*/\.*' | wc -l)
echo "Found ${startCount} files for processing in ${sourceDir}"

if [[ ${startCount} -gt 0 ]]; then
    python3 ${SORT_PHOTOS_PATH} ${sourceDir} ${photoDestDir} -r --sort %Y/%m --extensions ${PHOTO_EXTENSIONS} 
    python3 ${SORT_PHOTOS_PATH} ${sourceDir} ${videoDestDir} -r --sort %Y/%m --extensions ${VIDEO_EXTENSIONS} 

    endCount=$(find ${sourceDir} -maxdepth 1 -type f | wc -l)

    if [[ ${endCount} -lt ${startCount} ]]; then
        echo "Start the index"
        curl -H "Authorization: Bearer ${PP_API_KEY}" -d '{"path":"/","rescan":false,"cleanup":false}' "${PP_HOST}/api/v1/index"
    else
        echo "No files moved skipping index"
    fi
fi