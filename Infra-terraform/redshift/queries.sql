CREATE TABLE public.reddit (
    id                     VARCHAR(50),
    author                 VARCHAR(100),
    title                  VARCHAR(500),
    subreddit              VARCHAR(100),
    ups                    INT,
    upvote_ratio           FLOAT4,
    num_comments           INT,
    score                  INT,
    created_utc            TIMESTAMP,
    subreddit_subscribers  INT,
    total_awards_received  INT,
    num_crossposts         INT,
    over_18                BOOLEAN,
    edited                 VARCHAR(50)
);

COPY public.reddit
FROM 's3://reddit-pipeline1234/transformed/csvfilename'
IAM_ROLE 'arn:aws:iam::<account-id>:role/AmazonRedshiftS3AccessRole'
FORMAT AS CSV
DELIMITER ','
IGNOREHEADER 1
FILLRECORD TRUNCATECOLUMNS
ACCEPTINVCHARS
MAXERROR 10
REGION 'eu-west-3';


