#!/usr/bin/env nextflow
/*
========================================================================================
                         Popolipo
========================================================================================
 Popolipo Analysis Pipeline. Started 2018-05-07.
 #### Homepage / Documentation
 https://github.com/Hammarn/Popolipo
 #### Authors
 Hammarn Hammarn <rickard.hammaren@ebc.uu.se> - https://github.com/Hammarn>
----------------------------------------------------------------------------------------
*/


def helpMessage() {
    log.info"""
    =========================================
     Popolipo v${params.version}
    =========================================
    Usage:

    The typical command for running the pipeline is as follows:

    nextflow run Popolipo --reads '*_R{1,2}.fastq.gz' -profile docker

    Mandatory arguments:

    Options:

    References                      If not specified in the configuration file or you wish to overwrite any of the references.

    Other options:
      --outdir                      The output directory where the results will be saved
      --email                       Set this parameter to your e-mail address to get a summary e-mail with details of the run sent to you when the workflow exits
      -name                         Name for the pipeline run. If not specified, Nextflow will automatically generate a random mnemonic.
    """.stripIndent()
}

/*
 * SET UP CONFIGURATION VARIABLES
 */

// Show help emssage
if (params.help){
    helpMessage()
    exit 0
}

// Configurable variables
params.name = false
params.email = false
params.plaintext_email = false



output_docs = file("$baseDir/docs/output.md")



// Has the run name been specified by the user?
//  this has the bonus effect of catching both -name and --name
custom_runName = params.name
if( !(workflow.runName ==~ /[a-z]+_[a-z]+/) ){
  custom_runName = workflow.runName
}

/*
 * Create a channel for input read files
 */
params.input = '*.bed'
//inputChannel = sample.endsWith("bed") ? Channel.fromPath( '${sample.baseName}.{bed,bim,fam}' )
//: Channel.fromPath( '${sample}.{bed,bim,fam}' )


println params.input
//def bimbam (sample){
//    $sample = sample
    //sample = "${sample}"
Channel.from(${params.input} + ".bed", ${params.input} + ".bim", ${params.input} + ".fam").set {  inputChannel } 

println inputChannel
// Header log info
log.info "========================================="
log.info " Popolipo v${params.version}"
log.info "========================================="
def summary = [:]
summary['Run Name']     = custom_runName ?: workflow.runName
summary['input']        = params.input
summary['Max Memory']   = params.max_memory
summary['Max CPUs']     = params.max_cpus
summary['Max Time']     = params.max_time
summary['Output dir']   = params.outdir
summary['Working dir']  = workflow.workDir
summary['Container']    = workflow.container
if(workflow.revision) summary['Pipeline Release'] = workflow.revision
summary['Current home']   = "$HOME"
summary['Current user']   = "$USER"
summary['Current path']   = "$PWD"
summary['Script dir']     = workflow.projectDir
summary['Config Profile'] = workflow.profile
if(params.email) summary['E-mail Address'] = params.email
log.info summary.collect { k,v -> "${k.padRight(15)}: $v" }.join("\n")
log.info "========================================="


// Check that Nextflow version is up to date enough
// try / throw / catch works for NF versions < 0.25 when this was implemented
try {
    if( ! nextflow.version.matches(">= $params.nf_required_version") ){
        throw GroovyException('Nextflow version too old')
    }
} catch (all) {
    log.error "====================================================\n" +
              "  Nextflow version $params.nf_required_version required! You are running v$workflow.nextflow.version.\n" +
              "  Pipeline execution will continue, but things may break.\n" +
              "  Please run `nextflow self-update` to update Nextflow.\n" +
              "============================================================"
}


process exclude_indels_ATCG { 
    
    input:
    set file(bim:'*.bim'), file(bed:'*.bed'), file(fam:'*.fam')  from inputChannel
    
    output:
    '*.bed'
    
    """
    echo $bim
    echo $bed
    echo $fam
    grep -P "\tI" $bim>> variants_to_remove
    grep -P  "\tD" $bim>> variants_to_remove

    grep -P "\tA\tT" $bim>> variants_to_remove
    grep -P "\tT\tA" $bim>> variants_to_remove
    grep -P "\tC\tG" $bim>> variants_to_remove
    grep -P "\tG\tC" $bim>> variants_to_remove

    plink --bfile $bed --exclude variants_to_remove --make-bed --out ${bed.baseName}_cleaned 
    """
}



