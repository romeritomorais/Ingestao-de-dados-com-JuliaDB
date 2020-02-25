using Dates
using JuliaDB

cd("/home/romerito/Documents/data/currencies")

files = glob("*.txt", pwd())

;head $(files[1])

println(round(sum(filesize, files) / 1024^3, digits=6)," MiB")

@time ingestao = loadtable(files, output="database", chunks=150,
                           header_exists=false,
                           colnames=["Date","Open","High","Low","Close","Volume","OpenInt"], 
                           colparsers=Dict(1 => dateformat"yyyymmdd"),
                           skiplines_begin=1,
                           indexcols=[1])

cd("/home/romerito/Documents/data/currencies/database")

;du -hs /home/romerito/Documents/data/currencies/database

using Plots
using JuliaDB
using Statistics
using JuliaDBMeta
using OnlineStats
using IndexedTables

@time db = load(pwd())

column = [":Open",":Close"]

@time table = select(db, (:Open, :Close))

percentual = 150;

perc = map(i -> i.Close + (i.Close * percentual) / 100, table);
table = transform(table, :Perc => perc)

dif = map(i -> i.Close - i.Open , table);
table = transform(table, :Dif => dif)

@where table :Open > :Close



















partitionplot(table, :Open; stat = Mean(), seriestype = :bar)




