require(dplyr)

# nogcireq: vetor ou lista de tempos de resposta das requisições com NOGCI
# nogcierr: número de requisições que falharam
# gcireq: vetor ou lista de tempos de resposta das requisições com GCI
# gcierr: número de requisições que falharam no GCI
# zeroreq: vetor ou lista de tempos de resposta das requisições com Zero Coletas
# zeroerr: número de requisições que falharam no Zero Coletas
print_summary_table <- function(nogcireq, nogcierr, gcireq, gcierr, zeroreq, zeroerr) {
  cat("#fail:", "NG:", nogcierr, "\t | ", "G:", gcierr, "\t| ", "ZC:", zeroerr,  "\n")
  cat("#req: ", "NG:", NROW(nogcireq), " | ", "G:", NROW(gcireq), "\t| ", "ZC:", NROW(zeroreq), "\n")
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
  stats(nogcireq, "NG")
  stats(gcireq, " G")
  stats(zeroreq, "ZC")
}
