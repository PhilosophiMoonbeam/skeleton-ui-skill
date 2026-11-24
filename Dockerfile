FROM caddy:2.10.2-alpine

# Port 8080 needs no file capability, which would prevent exec with cap_drop: ALL.
RUN setcap -r /usr/bin/caddy

COPY --chmod=0644 deploy/index.html /srv/index.html
COPY --chmod=0644 skills/svelte-ui-eco/SKILL.md /srv/skills/svelte-ui-eco/SKILL.md
COPY --chmod=0644 skills/svelte-ui-eco/references/*.md /srv/skills/svelte-ui-eco/references/
COPY --chmod=0644 skills/svelte-ui-eco/examples/README.md skills/svelte-ui-eco/examples/*.svelte /srv/skills/svelte-ui-eco/examples/
# COPY's file mode can also reach implicit parent directories. Make the bundle traversable.
RUN find /srv/skills -type d -exec chmod 0755 {} + \
    && tar -czf /srv/svelte-ui-eco.tar.gz -C /srv/skills svelte-ui-eco

# Caddy's transient storage bookkeeping must not write to the read-only root.
ENV XDG_DATA_HOME=/dev/shm
USER 65534:65534
EXPOSE 8080
CMD ["caddy", "file-server", "--root", "/srv", "--listen", ":8080"]
