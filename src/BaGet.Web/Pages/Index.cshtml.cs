using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using BaGet.Core;
using BaGet.Protocol.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace BaGet.Web
{
    public class IndexModel : PageModel
    {
        private readonly ISearchService _search;

        public IndexModel(ISearchService search)
        {
            _search = search ?? throw new ArgumentNullException(nameof(search));
        }

        [BindProperty(SupportsGet = true)]
        public string PackageType { get; set; }

        [BindProperty(SupportsGet = true)]
        public string Framework { get; set; }

        [BindProperty(SupportsGet = true)]
        public bool? IncludePrerelease { get; set; }

        public IReadOnlyList<SearchResult> Packages { get; private set; }

        public async Task OnGetAsync(CancellationToken cancellationToken)
        {
            var search = await _search.SearchAsync(
                new SearchRequest
                {
                    Take = 20,
                    IncludeSemVer2 = true,
                },
                cancellationToken);

            Packages = search.Data;
        }
    }
}
