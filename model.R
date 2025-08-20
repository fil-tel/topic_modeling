library(dplyr)
library(readr)
library(parallel)
library(slendr)
library(ggplot2)
library(tidyr)
init_env()

Ne_ooa <- 2000

# bakcbine structure
anc <- population("ancestor",
                  time = 700e3,
                  N = 15000,
                  remove = 640e3)
afr <- population("AFR",
                  parent = anc,
                  time = 650e3,
                  N = 15000)
nea <- population(
  "NEA",
  parent = anc,
  time = 650e3,
  N = 2000,
  remove = 39e3
)

ooa <- population(
  "OOA",
  parent = afr,
  time = 70e3,
  N = Ne_ooa,
  remove = 39e3
)


ana <- population(
  "ANA",
  parent = ooa,
  time = 40e3,
  N = 5000
)

whg <- population(
  "WHG",
  parent = ooa,
  time = 40e3,
  N = 5000
)

yam <- population(
  "YAM",
  parent = ooa,
  time = 40e3,
  N = 5000
)

# eur <- population("EUR",
#                   parent = whg,
#                   time = 3e3,
#                   N = 15000)

gf <- c(
  list(
    gene_flow(
      from = nea,
      to = ooa,
      rate = 0.03,
      start = 49000,
      end = 45000,
      overlap = FALSE
    )
  )
)

model <- compile_model(
  populations = list(anc, afr, nea, ooa, yam, whg, ana),
  gene_flow = gf,
  generation_time = 30,
  serialize = FALSE,
  time_units = "years before present"
)

schedule <- rbind(
  schedule_sampling(model, times = 0, list(ana, 50)),
  schedule_sampling(model, times = 0, list(yam, 50)),
  schedule_sampling(model, times = 0, list(whg, 50)),
  schedule_sampling(model, times = 0, list(afr, 50))
)
#
plot_model(
  model
)

ts <- msprime(
  model,
  sequence_length = 100e6,
  recombination_rate = 1e-8,
  samples = schedule
) %>% ts_mutate(1e-8)

# extract genotyoes
geno_df <- ts_genotypes(ts)

# convert pos column in geno_df to rownmaes
geno_df <- geno_df %>% mutate(pos=paste0("chr1:", pos, "-", pos)) %>% tibble::column_to_rownames(var = "pos")
# extract only a 30% of the sites
geno_small_df <- geno_df[sample(nrow(geno_df), round(nrow(geno_df)*0.3)), ]


# create metadata
# metadata <- data.frame()

library(cisTopic)

cisTopicObject <-
  createcisTopicObject(geno_small_df, project.name = 'topic_admix')
# cisTopicObject <-
  # addCellMetadata(cisTopicObject, cell.data = metadata)
cisTopicObject <-
  runWarpLDAModels(
    cisTopicObject,
    topic = c(3,4,5),
    seed = 123,
    addModels = FALSE,
    nCores = 2
  )
# way of selecting best model
cisTopicObject <- selectModel(cisTopicObject, type='maximum')
cisTopicObject <- selectModel(cisTopicObject, type='perplexity')
cisTopicObject <- selectModel(cisTopicObject, type='derivative')
# select 4 topics as a test
# 4 because there are 4 populations, so ideally 4 topics should descrive them
cisTopicObject <- selectModel(cisTopicObject, select = 4)
# extract percentage of topic per sampled individual
topics_samples <- t(cisTopicObject@selected.model$document_expects) %>% as.data.frame() %>% setNames(paste0("Topic_", 1:ncol(.))) %>% mutate(pop=substr(rownames(.), 1, 3)) %>% tibble::rownames_to_column("sample")

# long format for plotting
topics_samples_long <- topics_samples %>% pivot_longer(cols = !c(pop, sample), names_to = "topic", values_to = "percentage")

# plot the topics per sample
topics_samples_long %>% ggplot()+geom_bar(mapping = aes(sample, percentage, fill = topic), stat = "identity") + facet_wrap(~pop, scales = "free_x") +theme(axis.text.x = element_blank())


