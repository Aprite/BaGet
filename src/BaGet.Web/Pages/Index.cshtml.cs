using System;
using System.Threading;
using System.Threading.Tasks;
using BaGet.Core;
using BaGet.Protocol.Models;
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

        public SearchResponse SearchResults { get; private set; }

        public async Task OnGetAsync(CancellationToken cancellationToken)
        {
            SearchResults = await _search.SearchAsync(
                new SearchRequest
                {
                    Take = 20,
                    IncludeSemVer2 = true,
                },
                cancellationToken);
        }
    }
}
