## Step 1. Data Cleaning & preprocessing

So at first what I did was use the remove duplicates function in Excel to remove all the duplicates so only the geolocation data set had some duplicates which I deleted.

Then I started creating a master data sheet where I will accumulate all the data from other tables into it. I used Xlookup for that.

Finally I realised that the dataset has more than 99,000 rows which is too time consuming for the ms excel. So what I did was I kept 2000 rows and deleted the remaining rows.

Now how did I do that? so I actually created a `random_index` and using the `RAND` function I generated some random numbers for all the 99k+ rows. Then I sorted them & finally I kept only the first 2000 rows which were actually randomly shuffled. Then I deleted the remaining all of them.

## EDA
