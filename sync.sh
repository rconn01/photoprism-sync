#! /bin/bash


while getopts "s:d:h:t:e:" opt; do
  case ${opt} in
    s) sourceDir=$OPTARG ;;
    d) destDir=$OPTARG ;;
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
	python3 ${SORT_PHOTOS_PATH} ${sourceDir} ${destDir} -r --sort %Y/%m --extensions jpg gif png 

	endCount=$(find ${sourceDir} -maxdepth 1 -type f | wc -l)

	if [[ ${endCount} -lt ${startCount} ]]; then
		echo "Start the index"
		curl -H "Authorization: Bearer ${PP_API_KEY}" -d '{"path":"/","rescan":false,"cleanup":false}' "${PP_HOST}/api/v1/index"
	fi
fi