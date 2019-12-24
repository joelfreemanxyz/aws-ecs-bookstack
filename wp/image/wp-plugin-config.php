$region = getenv('AWS_REGION');
$bucket = getenv('BUCKET_NAME');

define( 'AS3CF_SETTINGS', serialize( array(
    // Storage Provider ('aws', 'do', 'gcp')
    'provider' => 'aws',
    // Access Key ID for Storage Provider (aws and do only, replace '*')
    'access-key-id' => '********************',
    // Secret Access Key for Storage Providers (aws and do only, replace '*')
    'secret-access-key' => '**************************************',
    // GCP Key File Path (gcp only)
    // Make sure hidden from public website, i.e. outside site's document root.
    'key-file-path' => '/path/to/key/file.json',
    // Use IAM Roles on Amazon Elastic Compute Cloud (EC2) or Google Compute Engine (GCE)
    'use-server-roles' => true,
    // Bucket to upload files to
    'bucket' => $bucket,
    // Bucket region (e.g. 'us-west-1' - leave blank for default region)
    'region' => $region,
    // Automatically copy files to bucket on upload
    'copy-to-s3' => true,
    // Rewrite file URLs to bucket
    'serve-from-s3' => true,
    // Bucket URL format to use ('path', 'cloudfront')
    'domain' => 'path',
    // Custom domain if 'domain' set to 'cloudfront'
    'cloudfront' => 'cdn.exmple.com',
    // Enable object prefix, useful if you use your bucket for other files
    'enable-object-prefix' => true,
    // Object prefix to use if 'enable-object-prefix' is 'true'
    'object-prefix' => 'wp-content/uploads/',
    // Organize bucket files into YYYY/MM directories
    'use-yearmonth-folders' => true,
    // Serve files over HTTPS
    'force-https' => false,
    // Remove the local file version once offloaded to bucket
    'remove-local-file' => true,
    // Append a timestamped folder to path of files offloaded to bucket
    'object-versioning' => true,
) ) );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}
