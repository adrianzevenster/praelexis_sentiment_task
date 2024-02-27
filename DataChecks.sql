###############################
## Data Volume and Validations#
###############################

-- Distinct tweet_id: 14 485
-- Row Count: 14 485
select count(distinct tweet_id) from Tweets;

select count(distinct airline) from tweets;

select count(airline_sentiment), airline, airline_sentiment, avg(airline_sentiment_confidence)
from Tweets
-- where airline_sentiment_confidence
group by airline, airline_sentiment, airline_sentiment_confidence;

##################################################################
## -Average Confidence Score of Sentiment Predictions per airline#
## -Total counts for each sentiment group based on airline########
##################################################################
select confidence.airline,
       confidence.airline_sentiment,
       confidence.avg_confidence,
       counts.sentiment_count,
       confidence.airline_sentiment_confidence
from(
    select airline, airline_sentiment, round(avg(airline_sentiment_confidence), 2) as avg_confidence, airline_sentiment_confidence
    from Tweets
-- where airline_sentiment_confidence
    group by airline, airline_sentiment) confidence
inner join (
    select airline, airline_sentiment, count(airline_sentiment) as sentiment_count
    from Tweets
    group by airline, airline_sentiment) counts
where counts.airline = confidence.airline
and counts.airline_sentiment = confidence.airline_sentiment;



##############################################################
## Negative, Positive and Neutral Sentiment Ratio per Airline#
##############################################################
SELECT
    t1.airline,
    t1.airline_sentiment,
    t1.sentiment_count AS sentiment_count,
--     t2.total_sentiment_count AS total_sentiments_per_airline,
    round((t1.sentiment_count * 1.0 / t2.total_sentiment_count), 2) * 100 AS sentiment_ratio
FROM
    (SELECT
        airline,
        airline_sentiment,
        COUNT(*) AS sentiment_count
     FROM Tweets
     -- WHERE airline_sentiment_confidence
     GROUP BY airline, airline_sentiment) t1
INNER JOIN
    (SELECT
        airline,
        COUNT(*) AS total_sentiment_count
     FROM Tweets
     GROUP BY airline) t2
ON t1.airline = t2.airline;
