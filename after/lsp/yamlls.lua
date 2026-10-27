return {
    settings = {
        -- Stop the "telemetry" notification yamlls sends on startup
        redhat = { telemetry = { enabled = false } },
        yaml = {
            -- Schemas come from the `# yaml-language-server: $schema=...` modeline
            -- or from SchemaStore (k8s, GitHub Actions, docker-compose, ...)
            schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
            },
            completion = true,
            hover = true,
            validate = true,
            format = { enable = false }, -- conform/prettierd handles formatting
            keyOrdering = false,
        },
    },
}
