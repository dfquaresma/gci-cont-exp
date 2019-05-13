require(dplyr)

# nogcireq: vetor ou lista de tempos de resposta das requisições com NOGCI
# nogcierr: número de requisições que falharam
# gcireq: vetor ou lista de tempos de resposta das requisições com GCI
# gcierr: número de requisições que falharam no GCI
# zeroreq: vetor ou lista de tempos de resposta das requisições com Zero Coletas
# zeroerr: número de requisições que falharam no Zero Coletas
table_it <- function(runtime_language, nogcireq, nogcierr, gcireq, gcierr, zeroreq, zeroerr) {
  cat("#fail:", paste(runtime_language, "NG:", sep=""), nogcierr, " | ", 
      paste(runtime_language, "G:", sep=""), gcierr, " | ", 
      paste(runtime_language, "ZC:", sep=""), zeroerr,  "\n")
  cat("#req: ", paste(runtime_language, "NG:", sep=""), NROW(nogcireq), " | ", 
      paste(runtime_language, "G:", sep=""), NROW(gcireq), " | ", 
      paste(runtime_language, "ZC:", sep=""), NROW(zeroreq), "\n")
  stats <- function(df, tag) {
    p50 = quantile(df, 0.5)
    p95 = quantile(df, 0.95)
    p99 = quantile(df, 0.99)
    p999 = quantile(df, 0.999)
    p9999 = quantile(df, 0.9999)
    p99999 = quantile(df, 0.99999)
    
    cat("Latency(ms) ", tag, " ")
    cat("avg:", signif(t.test(df)$conf.int, digits = 2), " | ")
    cat("50:", signif(p50, digits = 4), " | ")
    cat("95:", signif(p95, digits = 4), " | ")
    cat("99:", signif(p99, digits = 4), " | ")
    cat("99.9:", signif(p999, digits = 4), " | ")
    cat("99.99:", signif(p9999, digits = 4), " | ") 
    cat("99.999:", signif(p99999, digits = 4), " | ") 
    cat("Dist.Tail.:", signif(p99999-p50, digits = 4)) 
    cat("\n")
  }
  stats(nogcireq, paste(runtime_language, "NG", sep=""))
  stats(gcireq, paste(runtime_language, "G ", sep=""))
  stats(zeroreq, paste(runtime_language, "ZC", sep=""))
}

print_summary_table <- function(path, runtime_language, experiment, round) {
  nogci_path = paste(path, runtime_language, "nogci-access-e", experiment, "r", round, ".log", sep="")
  gci_path = paste(path, runtime_language, "gci-access-e", experiment, "r", round, ".log", sep="")
  zero_path = paste(path, runtime_language, "zero-access-e", experiment, "r", round, ".log", sep="")
    
  nogci = read.csv(nogci_path, sep=";",header=T, dec=".")
  nogci = tail(gonogci, -100)
  nogci.req <- as.vector(filter(gonogci, status == 200)$request_time) * 1000
  nogci.err <- nrow(filter(gonogci, status != 200))
  
  gci = read.csv(gci_path, sep=";",header=T, dec=".")
  gci = tail(gogci, -100)
  gci.req <- as.vector(filter(gogci, status == 200)$request_time) * 1000
  gci.err <- nrow(filter(gogci, status != 200))
  
  zero = read.csv(zero_path, sep=";",header=T, dec=".")
  zero = tail(gozero, -100)
  zero.req <- as.vector(filter(gozero, status == 200)$request_time) * 1000
  zero.err <- nrow(filter(gozero, status != 200))
  
  table_it(
    runtime_language,
    nogci.req, nogci.err, 
    gci.req, gci.err, 
    zero.req, zero.err
  )  
}
