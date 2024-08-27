# photoprism-sync

A simple bash script to be executed via cron that:

* Looks for any new files to a sftp drop location
* Uses sortPhotos to move them to the originals folder
* Executes an index

### Installation 

You must have [sortPhotos](https://github.com/rconn01/sortphotos/tree/LivePhotos) available and you must create an [api key](https://docs.photoprism.app/developer-guide/api/#client-authentication) with the scope of `photos` on your photoprism instance

### Usage

```
./sync.sh -s <sorceDirectory> -d <destinationDirectory> -h <photoPrismHost> -t <photoPrismToken> -e <pathToSourtPhotos>
```
